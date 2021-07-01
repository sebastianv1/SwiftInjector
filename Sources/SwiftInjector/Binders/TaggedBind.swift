import Foundation

public protocol Tag {
    associatedtype Element
}

public struct Tagged<T:Tag> {
    let getter: () -> T.Element
    
    public func get() -> T.Element {
        getter()
    }
}

public struct TaggedBind<T:Tag>: SingleFactoryBinding {
    public typealias Element = T.Element
    
    public var providers: [AnyProvider]
    
    
    public init(_ provider: AnyProvider) {
        self.providers = [
            AnyProvider(Tagged<T>.self, dependencies: provider.dependencies) { graph in
                Tagged<T> {
                    provider.factory(graph) as! T.Element
                }
            }
        ]
    }
}
