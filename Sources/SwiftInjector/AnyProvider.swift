import Foundation

public struct AnyProvider {
    let type: Any.Type
    let factory: (DependencyLocator) -> Any
    let dependencies: [Any.Type]
    let file: StaticString?
    let line: Int?
    
    public init(_ type: Any.Type, dependencies: [Any.Type], file: StaticString? = nil, line: Int? = nil,  _ factory: @escaping (DependencyLocator) -> Any) {
        self.type = type
        self.dependencies = dependencies
        self.file = file
        self.line = line
        self.factory = factory
    }
}

extension AnyProvider: Equatable {
    public static func == (lhs: AnyProvider, rhs: AnyProvider) -> Bool {
        lhs.type == rhs.type
            && lhs.dependencies.map { ObjectIdentifier($0) } == rhs.dependencies.map { ObjectIdentifier($0) }
            && lhs.line == rhs.line
    }
}
