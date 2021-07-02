import Foundation

struct ValidationError: Error, CustomStringConvertible {
    var description: String {
        errors.map { $0.description }.joined(separator: "\n")
    }
    
    var errors: [GraphError] = []
}

extension AnyProvider: CustomStringConvertible {
    public var description: String {
        var desc = "\(type)"
        if let file = file, let line = line {
            desc += " \(file):\(line)"
        }
        return desc
    }
}

extension ScopeBuilder {
    static func validate() throws {
        try ScopeValidator<S>(S.self).validate()
    }
}


enum GraphError: Error {
    case duplicateBindings([AnyProvider])
    case missingDependency(dependency:Any.Type, parent: AnyProvider)
    case dependencyCycle([AnyProvider])
}

extension GraphError: CustomStringConvertible {
    var description: String {
        switch self {
        case .duplicateBindings(let duplicateBindings):
            var error = "Duplicate bindings found for \(duplicateBindings.first!.type)\n"
            duplicateBindings.forEach { provider in
                error += "  --> Found \(provider)\n"
            }
            return error
        case .missingDependency(let dependency, let parent):
            return "Missing dependency \(dependency)\n  --> Depended upon by \(parent)"
        case .dependencyCycle(let cycle):
            var error = "Dependency cycle found!"
            cycle.enumerated().forEach { args in
                let (idx, provider) = args
                if idx == cycle.endIndex - 1 {
                    error += "  \(provider)"
                } else {
                    error += "  \(provider) depends upon -->\n"
                }
            }
            return error
        }
    }
}


struct ScopeValidator<S:Scope> {
    private let scope: S.Type
    
    init(_ scope: S.Type) {
        self.scope = scope
    }
    public func validate() throws {
        var objectsMap: [ObjectIdentifier:[AnyProvider]] = [:]
        objectsMap[ObjectIdentifier(scope.root.singleProvider.type), default: []] += [scope.root.singleProvider]
        objectsMap[ObjectIdentifier(S.Args.self), default: []] += [AnyProvider(scope.Args.self, dependencies: [], { locator in
            fatalError("")
        })]
        scope.objects.providers.forEach { provider in
            objectsMap[ObjectIdentifier(provider.type), default: []] += [provider]
        }
        
        let uniqueObjectMap = try validateUniqueBindings(objectsMap)
        try validateDependencies(uniqueObjectMap)
        try validateSubscopes(uniqueObjectMap)
        try validateAcyclic(uniqueObjectMap)
        // Cycle validation
        
    }
}

extension ScopeValidator {
    fileprivate func validateAcyclic(_ uniqueObjectMap: [ObjectIdentifier:AnyProvider]) throws {
        func _validateAcyclic(stack: [AnyProvider], seen: inout Set<ObjectIdentifier>) throws {
            if stack.count == 0 {
                return
            }
            let top = stack.first!
            if seen.contains(top.hashedType) {
                return
            }
            
            if stack[1...].contains(top) {
                // Cycle
                let cycle = stack
                    .reversed()
                    .suffix(from: stack.firstIndex(of: top)!)
                throw ValidationError(errors: [.dependencyCycle(Array(cycle))])
            }
            
            let dependencies = top.dependencies.map { uniqueObjectMap[ObjectIdentifier($0)]! }
            try dependencies.forEach { dep in
                try _validateAcyclic(stack: [dep] + stack, seen: &seen)
            }
            
            seen.insert(top.hashedType)
        }
        
        var seen: Set<ObjectIdentifier> = .init()
        try _validateAcyclic(stack: [scope.root.singleProvider], seen: &seen)
    }
    
    fileprivate func validateUniqueBindings(_ objectsMap: [ObjectIdentifier:[AnyProvider]]) throws -> [ObjectIdentifier:AnyProvider] {
        let duplicateBindings = objectsMap
            .values
            .filter { $0.count > 1 }
        
        let duplicateBindingErrors = duplicateBindings.map { GraphError.duplicateBindings($0) }
        if duplicateBindingErrors.count > 0 {
            throw ValidationError(errors: duplicateBindingErrors)
        }
        
        return objectsMap.mapValues { $0.first! }
    }
    
    fileprivate func validateSubscopes(_ uniqueObjectMap: [ObjectIdentifier:AnyProvider]) throws {
        try uniqueObjectMap.forEach { args in
            let (_, provider) = args
            if let subscopeType =  provider.type as? ScopeBuilderProtocol.Type {
                try subscopeType.validate()
            }
        }
    }
    
    fileprivate func validateDependencies(_ uniqueObjectMap: [ObjectIdentifier:AnyProvider]) throws {
        var errors: [GraphError] = []
        for args in uniqueObjectMap {
            let (_, provider) = args
            if let _ = provider.type as? ScopeBuilderProtocol.Type {
                continue
            }
            
            provider.dependencies.forEach { dep in
                if uniqueObjectMap[ObjectIdentifier(dep)] == nil {
                    errors.append(.missingDependency(dependency: dep, parent: provider))
                }
            }
        }
        
        if errors.count > 0 {
            throw ValidationError(errors: errors)
        }
    }
}


extension AnyProvider {
    var hashedType: ObjectIdentifier {
        ObjectIdentifier(type)
    }
}
