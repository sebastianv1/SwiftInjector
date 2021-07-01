import Foundation

public struct Bind<Element>: SingleFactoryBinding {
    var singleProvider: AnyProvider {
        return providers.first!
    }
    
    public let providers: [AnyProvider]
    
    public init(_ provider: AnyProvider) {
        self.providers = [
            provider,
            Self.lazyProvider(from: provider)
        ]
    }
}

extension SingleFactoryBinding {
    static func lazyProvider(from provider: AnyProvider) -> AnyProvider {
        AnyProvider(
            Lazy<Element>.self,
            dependencies: provider.dependencies,
            file: provider.file,
            line: provider.line) { graph in
            Lazy<Element> {
                provider.factory(graph) as! Element
            }
        }
    }
    
}
