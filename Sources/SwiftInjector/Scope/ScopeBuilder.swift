import Foundation

protocol ScopeBuilderProtocol {
    static func validate() throws
}

public struct RootScopeBuilder<S:Scope> {
    private let scope: S.Type
    public init(_ scope: S.Type) {
        self.scope = scope
    }
    
    public func build(_ args: S.Args) throws -> S.Root {
        try ScopeValidator<S>(scope).validate()
        return ScopeBuilder(scope).build(args)
    }
}

public struct ScopeBuilder<S:Scope>: ScopeBuilderProtocol {
    private let scope: S.Type
    init(_ scope: S.Type) {
        self.scope = scope
    }
    
    public func build(_ args: S.Args) -> S.Root {
        let graph = Graph()
        
        graph.insert(scope.Args.self, provider: AnyProvider(scope.Args.self, dependencies: [], { _ in
            args
        }))
        graph.insert(scope.root)
        let lazyRoot = AnyProvider(Lazy<S.Root>.self, dependencies: scope.root.singleProvider.dependencies) { graph in
            Lazy<S.Root> {
                scope.root.singleProvider.factory(graph) as! S.Root
            }
        }
        graph.insert(Lazy<S.Root>.self, provider: lazyRoot)
        scope.objects.providers.forEach { provider in
            graph.insert(provider.type, provider: provider)
        }
        
        return graph[scope.Root.self]
    }
}
