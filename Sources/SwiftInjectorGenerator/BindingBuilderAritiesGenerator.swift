//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 7/1/21.
//

import Foundation

struct BindingBuilderAritiesGenerator {
    static func generate(range: Range<Int>) -> String {
        var buffer = "// CODE GENERATED. DO NOT EDIT\n"
        buffer += "import Foundation\n\n"
        buffer += "extension BindingBuilder {\n\n"
        range.forEach { n in
            buffer += generateBuildBlock(n)
        }
        buffer += "}"
        
        return buffer
    }
    
    static private func generateBuildBlock(_ arity: Int) -> String {
        precondition(arity > 0)
        
        let genericParams = (1...arity).map { n -> String in
            if n == arity {
                return "B_\(n-1):Binding"
            } else {
                return "B_\(n-1):Binding, "
            }
        }.joined()
        let params = (1...arity).map { n -> String in
            if n == arity {
                return "_ arg\(n-1): B_\(n-1)"
            } else {
                return "_ arg\(n-1): B_\(n-1), "
            }
        }.joined()
        let groupBindingDecl = (1...arity).map { n -> String in
            if n == arity {
                return "arg\(n-1).providers"
            } else {
                return "arg\(n-1).providers + "
            }
        }.joined()
        var funcBuffer = String.indent(tabs: 1) + "public static func buildBlock<\(genericParams)>(\(params)) -> Group {\n"
        funcBuffer += String.indent(tabs: 2) + "return Group(\(groupBindingDecl))\n"
        funcBuffer += String.indent(tabs: 1) + "}\n\n"
        return funcBuffer
    }
}
