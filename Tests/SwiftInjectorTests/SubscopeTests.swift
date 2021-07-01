//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 6/29/21.
//

import Foundation
import SwiftInjector
import XCTest

fileprivate struct TestRoot {
    let string: String
    let subscopeBuilder: ScopeBuilder<TestSubscope>
    
    func login(_ sessionToken: String) -> Account {
        subscopeBuilder.build(sessionToken)
    }
}

fileprivate struct TestScope: Scope {
    typealias Root = TestRoot
    
    static var root: Bind<TestRoot> {
        Bind(TestRoot.self, factory: TestRoot.init)
    }
    
    static var objects: some Binding {
        Group {
            Bind(String.self) { "Hello World!" }
            Subscope(TestSubscope.self)
        }
    }
}

fileprivate struct LoggedInService {
    let session: String
}

fileprivate struct TestSubscope: Scope {
    typealias Args = String
    typealias Root = Account
    
    static var root: Bind<Account> {
        Bind(Account.self, factory: Account.init)
    }
    
    static var objects: some Binding {
        Group {
            Bind(LoggedInService.self, factory: LoggedInService.init)
        }
    }
}

fileprivate struct Account {
    let sessionToken: String
    let loggedInService: LoggedInService
}

class SubscopeTests: XCTestCase {
    func testSubscope() {
        let root = try! RootScopeBuilder(TestScope.self).build(())
        XCTAssertEqual(root.string, "Hello World!")
        let account = root.login("session-token")
        XCTAssertEqual(account.sessionToken, "session-token")
        XCTAssertEqual(account.loggedInService.session, "session-token")
    }
}
