import Foundation
import ArgumentParser

struct InjectorGenerator: ParsableCommand {
    @Option var bindingArityFile: String?
    @Option var factoryArityFile: String?
    @Option var builderArityFile: String?
    @Option var userArityCount: Int?
    
    mutating func run() throws {
        let arityRange: Range<Int>
        let builderArityRange: Range<Int>
        if let userArityCount = userArityCount {
            arityRange = (11..<userArityCount)
            builderArityRange = (12..<userArityCount + 1)
        } else {
            arityRange = (0..<11)
            builderArityRange = (1..<11)
        }
        
        if let bindingArityFile = bindingArityFile {
            try BindingAritiesGenerator
                .generate(range: arityRange)
                .write(toFile: bindingArityFile, atomically: true, encoding: .utf8)
        }
        if let factoryArityFile = factoryArityFile {
            try FactoryAritiesGenerator
                .generate(range: arityRange)
                .write(toFile: factoryArityFile, atomically: true, encoding: .utf8)
        }
        if let builderArityFile = builderArityFile {
            try BindingBuilderAritiesGenerator
                .generate(range: builderArityRange)
                .write(toFile: builderArityFile, atomically: true, encoding: .utf8)
        }
    }
}

InjectorGenerator.main()
