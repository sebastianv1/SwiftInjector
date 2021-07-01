import Foundation

public struct Subscope<S:Scope>: Binding {
    public let providers: [AnyProvider]
    
    public init(_ subscope: S.Type) {
        self.providers = [
            AnyProvider(ScopeBuilder<S>.self, dependencies: [], { graph in
                ScopeBuilder<S>(S.self)
            })
        ]
    }
}
