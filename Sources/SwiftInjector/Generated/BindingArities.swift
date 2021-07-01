// CODE GENERATED. DO NOT EDIT
import Foundation

extension SingleFactoryBinding {

    public init(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping () -> Element) {
        self.init(
            AnyProvider(type, dependencies: [], file: file, line: line, { locator in
                factory()
            })
        )
    }

    public init<P_0>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self], file: file, line: line, { locator in
                factory(
                    locator[P_0])
            })
        )
    }

    public init<P_0, P_1>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1])
            })
        )
    }

    public init<P_0, P_1, P_2>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2])
            })
        )
    }

    public init<P_0, P_1, P_2, P_3>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2, P_3) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self, P_3.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2],
                    locator[P_3])
            })
        )
    }

    public init<P_0, P_1, P_2, P_3, P_4>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2, P_3, P_4) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self, P_3.self, P_4.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2],
                    locator[P_3],
                    locator[P_4])
            })
        )
    }

    public init<P_0, P_1, P_2, P_3, P_4, P_5>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2, P_3, P_4, P_5) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self, P_3.self, P_4.self, P_5.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2],
                    locator[P_3],
                    locator[P_4],
                    locator[P_5])
            })
        )
    }

    public init<P_0, P_1, P_2, P_3, P_4, P_5, P_6>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2, P_3, P_4, P_5, P_6) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self, P_3.self, P_4.self, P_5.self, P_6.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2],
                    locator[P_3],
                    locator[P_4],
                    locator[P_5],
                    locator[P_6])
            })
        )
    }

    public init<P_0, P_1, P_2, P_3, P_4, P_5, P_6, P_7>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2, P_3, P_4, P_5, P_6, P_7) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self, P_3.self, P_4.self, P_5.self, P_6.self, P_7.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2],
                    locator[P_3],
                    locator[P_4],
                    locator[P_5],
                    locator[P_6],
                    locator[P_7])
            })
        )
    }

    public init<P_0, P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self, P_3.self, P_4.self, P_5.self, P_6.self, P_7.self, P_8.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2],
                    locator[P_3],
                    locator[P_4],
                    locator[P_5],
                    locator[P_6],
                    locator[P_7],
                    locator[P_8])
            })
        )
    }

    public init<P_0, P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8, P_9>(
        _ type: Element.Type,
        _ file: StaticString = #file,
        _ line: Int = #line,
        factory: @escaping (P_0, P_1, P_2, P_3, P_4, P_5, P_6, P_7, P_8, P_9) -> Element) {
        self.init(
            AnyProvider(type, dependencies: [P_0.self, P_1.self, P_2.self, P_3.self, P_4.self, P_5.self, P_6.self, P_7.self, P_8.self, P_9.self], file: file, line: line, { locator in
                factory(
                    locator[P_0],
                    locator[P_1],
                    locator[P_2],
                    locator[P_3],
                    locator[P_4],
                    locator[P_5],
                    locator[P_6],
                    locator[P_7],
                    locator[P_8],
                    locator[P_9])
            })
        )
    }

}
