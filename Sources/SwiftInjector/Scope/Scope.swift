import Foundation

public protocol Scope {
    associatedtype Args = Void
    associatedtype Root
    associatedtype Binder: Binding
    
    static var root: Bind<Root> { get }
    static var objects: Binder { get }
}
