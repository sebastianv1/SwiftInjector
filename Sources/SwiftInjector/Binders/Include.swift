import Foundation

public struct Include: Binding {
    public let providers: [AnyProvider]
    
    public init<M:Module>(_ module: M.Type) {
        self.providers = M.objects.providers
    }
}
