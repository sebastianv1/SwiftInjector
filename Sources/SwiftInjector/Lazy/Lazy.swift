import Foundation

public struct Lazy<E> {
    private let provider: () -> E
    init(_ provider: @escaping () -> E) {
        self.provider = provider
    }
    
    public func get() -> E {
        return provider()
    }
}
