import Foundation

@resultBuilder
public struct BindingBuilder {
    public static func buildBlock() -> Group {
        return Group([])
    }
}
