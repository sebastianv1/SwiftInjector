//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 6/29/21.
//

import Foundation
import SwiftInjector
import XCTest

fileprivate struct TestService {
    let int: Int
}

fileprivate struct TestRoot {
    let int: Int
    let lazyInt: Lazy<Int>
    let testService: TestService
}

fileprivate struct TestScope: Scope {
    typealias Root = TestRoot
    
    static var root: Bind<TestRoot> {
        Bind(TestRoot.self, factory: TestRoot.init)
    }
    
    static var objects: some Binding {
        Group {
            CachedBind(Int.self) {
                Int.random(in: 0...100)
            }
            Bind(TestService.self, factory: TestService.init)
        }
    }
}

class CachedBindingTests: XCTestCase {
    func testCachedBinding() {
        let scope = try! RootScopeBuilder(TestScope.self).build(())
        XCTAssertEqual(scope.int, scope.lazyInt.get())
        XCTAssertEqual(scope.int, scope.testService.int)
    }
}
