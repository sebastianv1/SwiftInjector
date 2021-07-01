//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 6/29/21.
//

import Foundation
import XCTest
import SwiftInjector

fileprivate struct TestRoot {
    let int: Int
    let lazyInt: Lazy<Int>
    let string: String
    let taggedCharacter: Tagged<CharacterTag>
}

fileprivate struct CharacterTag: Tag {
    typealias Element = Character
}

fileprivate struct TestScope: Scope {
    typealias Root = TestRoot
    
    static var root: Bind<TestRoot> {
        Bind(TestRoot.self, factory: TestRoot.init)
    }
    
    static var objects: some Binding {
        Group {
            Bind(Int.self) { 3 }
            Bind(String.self) { (int: Int) in
                "Hello \(int) Worlds!"
            }
            TaggedBind<CharacterTag>(Character.self) {
                "z"
            }
        }
    }
    
}

class BindingTests: XCTestCase {
    func testBindings() {
        let root = try! RootScopeBuilder(TestScope.self).build(())
        XCTAssertEqual(root.string, "Hello 3 Worlds!")
        XCTAssertEqual(root.int, 3)
        XCTAssertEqual(root.taggedCharacter.get(), "z")
    }
}
