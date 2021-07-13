
# SwiftInjector

A lightweight and opinionated dependency injection framework for Swift to help you eliminate long initializers and passthrough dependencies. 

### What is a Dependency Injection Framework?
A dependency injection (DI) framework is a data structure or container where you construct all the objects that exist in your application(s) object graph(s). For a more academic definition and examples of dependency injection [Wikipedia](https://en.wikipedia.org/wiki/Dependency_injection) is a very helpful resource. In short, performing dependency injection means always passing/injecting an object's dependencies from a parent instead of initializing them from inside the object.

Dependency injection is __not__ the following example with UIViewControllers:

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

What this means is that at the root of our application (i.e `UIApplicationDelegate` or `@main` declaration) is where we assign the responsibility for initializing the objects in our application's dependency graph and injecting them. Some sort of container object is where we perform ["inversion of control"](https://en.wikipedia.org/wiki/Inversion_of_control) and construct our graph. This practice can and has been done via "manual" dependency injection (example below), but __dependency injection frameworks & SwiftInjector serve the purpose to make this orchestration much easier.__

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

One goal of SwiftInjector was to avoid creating a clone of the widely adopted Java DI frameworks [Dagger](https://dagger.dev/) or [Guice](https://github.com/google/guice). Instead, we want to create a framework and API that feels at home within the Swift ecosystem and draws inspriation from popular Swift frameworks like SwiftUI. So let's get started!

#### Creating a `Scope`
The first thing you will create when using SwiftInjector is an object that conforms to `SwiftInjector.Scope`. A scope represents a group of objects that share a lifetime. For example, we will have an Application Scope that includes objects who can be constructed during the lifetime of our application such as an authentication service, welcome flow view & view controller etc. Another good example of a scope would be a Logged In Scope that would include objects whose lifetime and construction would only be available after successfully logging in.

Let's start by creating the root application scope for a Github app we're building.


```swift
struct GithubAppScope: SwiftInjector.Scope {
    typealias Root = GithubRootView
    
    static var root: Bind<Root> {
        Bind(GithubRootView.self) {
            GithubRootView()
        }
    }
    
    static var objects: some SwiftInjector.Binding {
        Group {}
    }
}

struct GithubRootView: View {
    // ...
}
```

Breaking down our `GithubAppScope` implementation for a `Scope`, we first define what our `Root` type will be. This is the root object ultimately returned when building our scope.

Our typelias for `Root` is then used for the first required property `static var root: Bind<Root>`, where we return an instance of a `Bind` generic around our `Root` (a.k.a `GithubRootView`). 

The `Bind` object is just a key-value mapping from the type (`GithubRootView.self`) to a closure that tells SwiftInjector how to construct that particular object. We ultimately call this key-value pair constructed by the `Bind<GithubRootView>` instance a __binding__.

The second required property `static var objects: some SwiftInjector.Binding` is where we construct (or create all the __bindings__) for the objects that belong to our Scope (`GithubAppScope`). For now, we we will only return 1 object in our scope which is the root. So we can simply return an empty `Group {}` for our `objects` property.

#### Building our Scope

We can build our new `GithubAppScope` using the `RootScopeBuilder` object.

```swift
@main
struct GithubApp: App {
    let githubRootView: GithubRootView = try! RootScopeBuilder(GithubAppScope.self).build(())
    
    var body: some Scene {
        WindowGroup {
            githubRootView
        }
    }
}
```

The `RootScopeBuilder` accepts a `Scope` type in its initializer, and then we call `build(())` on the scope builder and receive back the `Root` type from our scope. A primary feature of dependency injection frameworks and SwiftInjector is that they validate your object graph to ensure that there aren't cyclical dependencies, duplicate bindings etc. Thus, the `build(_:)` is a throwing function. We'll dive more into all the validations we provide later.

And that's it! Although this application does nothing, this is the first step in learning how using SwiftInjector can help you perform dependency injection correctly and avoid those long initializers and passthrough objects.

### Adding more Dependencies

Let's expand our Github app to make include a network object that fetches our repository ids.

```swift
struct GithubNetworkService {
    // Fetches and returns all repo ids
    func fetchRepositories(_ completion: ([Int]) -> Void) {
        // ...
    }
}
```

And inside our `GithubRootView` we dependency inject `GithubNetworkService` and fetch all the ids from our network service to display in the View.

```swift
struct GithubRootView: View {
    let githubNetworkService: GithubNetworkService
    @State var repoIDs: [Int] = []
    
    var body: some View {
        HStack {
            // ...
        }.onAppear {
            githubNetworkService.fetchRepositories { result in
                repoIDs = result
            }
        }
    }
}
```

When we compile our app, we will receive a very normal compilation error at the callsite of constructing our `GithubRootView` within the `Bind` factory.

```
 error: missing argument for parameter 'githubNetworkService' in call
            GithubRootView()
```

So now where do we construct our `GithubNetworkService` in order to pass it into our view's initializer? We do this in 2 steps:

1. We create a `Binding` implementation for the `GithubNetworkService` type like we did for `GithubRootView`.
2. We add `GithubNetworkService` as a dependency within our closure.

For the first step, we will add a `Bind` object inside our `Group` from the `objects` property above. This will create a binding for `GithubNetworkService` in our object graph.

```swift
static var objects: some SwiftInjector.Binding {
    Group {
        Bind(GithubNetworkService.self) {
            GithubNetworkService()
        }
    }
}
```

And when now we can pass this type into our closure for `GithubRootView` and pass it into our initializer.

```swift
static var root: Bind<Root> {
    Bind(GithubRootView.self) { (networkService: GithubNetworkService) in
        GithubRootView(githubNetworkService: networkService)
    }
}
```

Now we can build and run the app having successfully added a new object to our dependency graph!


