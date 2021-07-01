import Foundation

public protocol Module {
    associatedtype Binder: Binding
    
    static var objects: Binder { get }
}
