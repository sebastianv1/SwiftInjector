import Foundation

public struct AnyProvider {
    public let type: Any.Type
    public let factory: (DependencyLocator) -> Any
    public let dependencies: [Any.Type]
    public let file: StaticString?
    public let line: Int?
    
    public init(_ type: Any.Type, dependencies: [Any.Type], file: StaticString? = nil, line: Int? = nil,  _ factory: @escaping (DependencyLocator) -> Any) {
        self.type = type
        self.dependencies = dependencies
        self.file = file
        self.line = line
        self.factory = factory
    }
}

extension AnyProvider: Equatable {
    public static func == (lhs: AnyProvider, rhs: AnyProvider) -> Bool {
        lhs.type == rhs.type
            && lhs.dependencies.map { ObjectIdentifier($0) } == rhs.dependencies.map { ObjectIdentifier($0) }
            && lhs.line == rhs.line
    }
}
