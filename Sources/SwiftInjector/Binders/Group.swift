import Foundation

public struct Group: Binding {
    public typealias Element = Any
    
    public let providers: [AnyProvider]
    
    public init<Bindings:Binding>(@BindingBuilder bindingBuilder: () -> Bindings) {
        self.providers = bindingBuilder().providers
    }
    
    init(_ providers: [AnyProvider]) {
        self.providers = providers
    }
}
