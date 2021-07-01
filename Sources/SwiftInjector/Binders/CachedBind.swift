import Foundation

fileprivate class Cached<E> {
    var value: E? = nil
}

public struct CachedBind<E>: SingleFactoryBinding {
    public typealias Element = E
    
    public var providers: [AnyProvider]
    
    private let cached: Cached<E>
    
    public init(_ provider: AnyProvider) {
        let cached = Cached<E>()
        let cachedProvider = AnyProvider(provider.type, dependencies: provider.dependencies) { graph in
            if let cached = cached.value {
                return cached
            } else {
                cached.value = provider.factory(graph) as? E
                return cached.value!
            }
        }
        self.providers = [
            cachedProvider,
            Self.lazyProvider(from: cachedProvider)
        ]
        self.cached = cached
    }
}
