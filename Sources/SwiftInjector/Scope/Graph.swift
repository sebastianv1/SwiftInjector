import Foundation

public protocol DependencyLocator {
    subscript<T>(_ dependency: T.Type) -> T { get }
}

class Graph: DependencyLocator {
    subscript<T>(dependency: T.Type) -> T {
        fetch(dependency).factory(self) as! T
    }
    
    private var fancyDictionary: [ObjectIdentifier: AnyProvider] = [:]
    
    func insert<E>(_ binding: Bind<E>) {
        fancyDictionary[ObjectIdentifier(binding.singleProvider.type)] = binding.singleProvider
    }
    
    func insert(_ type: Any.Type, provider: AnyProvider) {
        fancyDictionary[ObjectIdentifier(type)] = provider
    }
    
    func fetch<T>(_ type: T.Type) -> AnyProvider {
        fancyDictionary[ObjectIdentifier(type)]!
    }
}
