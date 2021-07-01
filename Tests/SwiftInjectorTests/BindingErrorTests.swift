//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 6/29/21.
//

import Foundation
@testable import SwiftInjector
import XCTest

fileprivate struct TestRoot {
    let int: Int
    let string: String
}

fileprivate struct TestScope: Scope {
    typealias Root = TestRoot
    
    static var root: Bind<TestRoot> {
        Bind(Root.self, factory: Root.init)
    }
    
    static var objects: some Binding {
        Group {}
    }
}

class BindingErrorTests: XCTestCase {
    func testMissingBindings() {
        do {
            let _ = try RootScopeBuilder(TestScope.self).build(())
            XCTAssertTrue(false)
        } catch {
            let error = error as! ValidationError
            XCTAssertEqual(error.errors.count, 2)
        }
    }
}
