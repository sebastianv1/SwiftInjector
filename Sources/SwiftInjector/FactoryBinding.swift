import Foundation

public protocol AssistedFactoryBinding: Binding {
    associatedtype Element
    associatedtype Tag: FactoryTag
    
    init(_ provider: AnyProvider)
}
