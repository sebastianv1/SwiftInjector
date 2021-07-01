//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 6/30/21.
//

import Foundation
import SwiftInjector
import XCTest

fileprivate class A {
    init(b: B) {
        self.b = b
    }
    let b: B
}

fileprivate class B {
    init(c: C) {
        self.c = c
    }
    let c: C
}

fileprivate class C {
    init(d: A) {
        self.d = d
    }
    let d: A
}

fileprivate class D {
    
}

fileprivate struct TestScope: Scope {
    typealias Root = A
    
    static var root: Bind<A> {
        Bind(A.self, factory: A.init)
    }
    
    static var objects: some Binding {
        Group {
            Bind(B.self, factory: B.init)
            Bind(C.self, factory: C.init)
            Bind(D.self, factory: D.init)
        }
    }
}

class CycleTests: XCTestCase {
    func testCycles() {
        do {
            let _ = try RootScopeBuilder(TestScope.self).build(())
            XCTAssertTrue(false)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
