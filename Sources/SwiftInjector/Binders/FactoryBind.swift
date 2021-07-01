//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 6/30/21.
//

import Foundation

public protocol FactoryTag {
    associatedtype Args
    associatedtype Element
}

public struct Factory<F:FactoryTag> {
    let factory: (F.Args) -> F.Element
    
    public func build(args: F.Args) -> F.Element {
        factory(args)
    }
}

public struct FactoryBind<F:FactoryTag>: AssistedFactoryBinding {
    public typealias Tag = F
    public typealias Element = F.Element
    public let providers: [AnyProvider]
    
    public init(_ provider: AnyProvider) {
        self.providers = [provider]
    }
}
