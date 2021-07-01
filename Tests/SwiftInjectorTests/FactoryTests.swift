//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 6/30/21.
//

import Foundation
import SwiftInjector
import XCTest

fileprivate struct AssistedObject {
    let session: String
}

fileprivate struct TestFactory: FactoryTag {
    typealias Args = String
    typealias Element = AssistedObject
}

fileprivate struct TestRoot {
    let factory: Factory<TestFactory>
}

fileprivate struct TestScope: Scope {
    
    typealias Root = TestRoot
    
    static var root: Bind<TestRoot> {
        Bind(TestRoot.self, factory: TestRoot.init)
    }
    
    static var objects: some Binding {
        FactoryBind<TestFactory>(AssistedObject.self) { args in
            AssistedObject(session: args)
        }
    }
}

class FactoryTests: XCTestCase {
    func testFactoryBinding() {
        let root = try! RootScopeBuilder(TestScope.self).build(())
        let obj = root.factory.build(args: "session-token")
        XCTAssertEqual(obj.session, "session-token")
    }
}
