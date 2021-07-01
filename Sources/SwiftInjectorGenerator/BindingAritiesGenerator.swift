import Foundation

struct BindingAritiesGenerator {
    static func generate(range: Range<Int>) -> String {
        var buffer = "// CODE GENERATED. DO NOT EDIT\n"
        buffer += "import Foundation\n\n"
        buffer += "extension SingleFactoryBinding {\n\n"
        range.forEach { n in
            buffer += generateInit(n)
        }
        
        buffer += "}"
        return buffer
    }
    
    private static func generateInit(_ arity: Int) -> String {
        let paramsDecl = (0..<arity).map { n in
            return "P_\(n)" + ((n == arity - 1) ? "" : ", ")
        }.joined()
        let genericDecl = arity == 0 ? "" : "<\(paramsDecl)>"
        let typesDecl = (0..<arity).map { n in
            return "P_\(n).self" + ((n == arity - 1) ? "" : ", ")
        }.joined()
        
        var factoryDeclBuffer = "factory("
        (0..<arity).forEach { n in
            if n == (arity - 1) {
                factoryDeclBuffer += "\n" + String.indent(tabs: 5) + "locator[P_\(n)]"
            } else {
                factoryDeclBuffer += "\n" + String.indent(tabs: 5) + "locator[P_\(n)],"
            }
        }
        factoryDeclBuffer += ")"
            
        
        return """
            public init\(genericDecl)(
                _ type: Element.Type,
                _ file: StaticString = #file,
                _ line: Int = #line,
                factory: @escaping (\(paramsDecl)) -> Element) {
                self.init(
                    AnyProvider(type, dependencies: [\(typesDecl)], file: file, line: line, { locator in
                        \(factoryDeclBuffer)
                    })
                )
            }\n\n
        """
    }
    
}
