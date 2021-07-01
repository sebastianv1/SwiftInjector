//
//  File.swift
//  
//
//  Created by Sebastian Shanus on 7/1/21.
//

import Foundation

struct FactoryAritiesGenerator {
    static func generate(range: Range<Int>) -> String {
        var buffer = "// CODE GENERATED. DO NOT EDIT\n"
        buffer += "import Foundation\n\n"
        buffer += "extension AssistedFactoryBinding {\n\n"
        range.forEach { n in
            buffer += generateInit(n)
        }
        buffer += "}"
        return buffer
    }
    
    private static func generateInit(_ arity: Int) -> String {
        let paramsDecl = (0..<arity+1).map { n in
            var buf = ""
            if n == 0 {
                buf = "Tag.Args"
            } else {
                buf = "P_\(n-1)"
            }
            if n != arity {
                buf += ", "
            }
            return buf
        }.joined()
        let genericDecl: String
        if arity == 0 {
            genericDecl = ""
        } else {
            genericDecl = "<" + ((0..<arity).map { n in
                return "P_\(n)" + ((n == arity - 1) ? "" : ", ")
            }.joined()) + ">"
        }
        let typesDecl = (0..<arity).map { n in
            return "P_\(n).self" + ((n == arity - 1) ? "" : ", ")
        }.joined()
        
        var factoryDeclBuffer = "Factory<Tag> { args in\n"
        factoryDeclBuffer += String.indent(tabs: 5) + "factory("
        (0..<arity+1).forEach { n in
            var innerBuffer = "\n"
            if n == 0 {
                innerBuffer += String.indent(tabs: 6) + "args"
            } else {
                innerBuffer += String.indent(tabs: 6) + "locator[P_\(n-1)]"
            }
            if n != arity {
                innerBuffer += ","
            }
            factoryDeclBuffer += innerBuffer
        }
        factoryDeclBuffer += ") as! Self.Tag.Element\n"
        factoryDeclBuffer += String.indent(tabs: 4) + "}\n"
            
        
        return """
            public init\(genericDecl)(
                _ type: Element.Type,
                _ file: StaticString = #file,
                _ line: Int = #line,
                factory: @escaping (\(paramsDecl)) -> Element) {
                self.init(
                    AnyProvider(Factory<Tag>.self, dependencies: [\(typesDecl)], file: file, line: line, { locator in
                        \(factoryDeclBuffer)
                    })
                )
            }\n\n
        """
    }
    
    
}
