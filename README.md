
# SwiftInjector

A lightweight and opinionated dependency injection framework for Swift to help you eliminate long initializers and passthrough dependencies. 

### What is a Dependency Injection Framework?
A dependency injection (DI) framework is a data structure or container where you construct all the objects that exist in your application(s) object graph(s). For a more academic definition and examples of dependency injection [Wikipedia](https://en.wikipedia.org/wiki/Dependency_injection) is a very helpful resource. In short, performing dependency injection means always passing/injecting an object's dependencies from outside of its construction.

Dependency injection is __not__ the following View Controller example:
```swift
class ViewControllerA: UIViewController {
    let networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func onTap() {
        // !!! THIS IS NOT DEPENDENCY INJECTION !!!
        let viewControllerB = ViewControllerB(networkService: networkService)

        present(viewControllerB, animated: false)
    }
}
```

Notice how `NetworkService` is a "passthrough" dependency that `ViewControllerA` never uses and is _only_ used to construct `ViewControllerB`. This is __not__ dependency injection because `ViewControllerA` depends on `ViewControllerB` but is now responsible for constructing it. This is how we end up with long initializers with our objects used to turtle along dependencies.

The following is _proper_ dependency injection:
```swift
class ViewControllerA: UIViewController {
    let viewControllerB: ViewControllerB
    init(viewControllerB: ViewControllerB) {
        self.viewControllerB = viewControllerB
    }
    
    func onTap() {
        // NO MORE DEPENDENCY CONSTRUCTION
        // `ViewControllerB` dependency is properly injected.
        present(viewControllerB, animated: false)
    }
}

```

What this means is that at the root of our application (i.e `UIApplicationDelegate` or `@App` declaration) is where we assign the responsibility for constructing the objects in our application's dependency graph and injecting them. Some sort of container object is where we perform ["inversion of control"](https://en.wikipedia.org/wiki/Inversion_of_control) and construct our graph. __This practice can and has been done many times via "manual" dependency injection (example below), but dependency injection frameworks & SwiftInjector serve the purpose to make this orchestration much easier.__

```swift
class AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let rootVC = Container.build()
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    struct Container {
        func build() -> ViewControllerA {
            let networkService = NetworkService()
            let viewControllerB = ViewControllerB(networkService: networkService)
            let viewControllerA = ViewControllerA(viewControllerB: viewControllerB)
            return viewControllerA
        }
    }
}
```

### Getting Started with SwiftInjector
