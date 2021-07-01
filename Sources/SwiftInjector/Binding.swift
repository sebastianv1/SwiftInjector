import Foundation

public protocol Binding {
    var providers: [AnyProvider] { get }
}

public protocol SingleFactoryBinding: Binding {
    associatedtype Element
    init(_ provider: AnyProvider)
}
