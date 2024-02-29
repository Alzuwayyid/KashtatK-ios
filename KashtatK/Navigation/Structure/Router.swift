//
//  Router.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
/// `Router` is an observable object class that manages navigation and presentation within a SwiftUI app.
/// It provides a structured way to navigate between views and manage modal presentations, full-screen views,
/// and sheets, utilizing an observable state pattern for SwiftUI integration.
class Router: ObservableObject {
    /// Defines possible navigation and presentation routes within the app.
    enum Route {
        case navigation, sheet, fullScreen, modal
    }
    /// Holds the state of navigation and presentation, including paths and views being presented.
    struct State {
        var navigationPath: [ViewSpec] = [] // Tracks the navigation stack as an array of `ViewSpec`.
        var presentingSheet: ViewSpec? // The currently presented sheet, if any.
        var presentingFullScreen: ViewSpec? // The currently presented full-screen view, if any.
        var presentingModal: ViewSpec? // The currently presented modal view, if any.
        var isPresented: Binding<ViewSpec?> // A binding to the currently presented `ViewSpec`, allowing for dynamic presentation management.
    }
    
    // MARK: Properities
    @Published private(set) var state: State
    @Published var isTabBarVisible: Bool = true
    /// Initializes the router with a specific presentation binding.
    /// - Parameter isPresented: A binding to a `ViewSpec?` that allows for dynamic presentation.
    init(isPresented: Binding<ViewSpec?>) {
        self.state = State(isPresented: isPresented)
    }
    /// Returns a view for a given `ViewSpec` and navigation route as `AnyView` for type erasure.
    /// Currently, this function returns an empty view. This should be overridden in subclasses to provide actual views.
    /// - Parameters:
    ///   - spec: The `ViewSpec` specifying which view to build.
    ///   - route: The `Route` specifying how the view is to be presented.
    /// - Returns: An `AnyView` containing the specified view.
    func view(spec: ViewSpec, route: Route) -> AnyView {
        Text("").earseToAnyView()
    }
    
}

extension Router {
    /// Navigates to a specified view by appending it to the navigation stack.
    func navigateTo(_ viewSpec: ViewSpec) {
        state.navigationPath.append(viewSpec)
    }
    /// Navigates back by removing the last view from the navigation stack.
    func navigateBack() {
        state.navigationPath.removeLast()
    }
    /// Navigates back by a specified number of steps in the navigation stack.
    func navigateBack(by steps: Int) {
        state.navigationPath.removeLast(steps)
    }
    /// Replaces the current navigation stack with a new path.
    func replaceNavigationStack(path: [ViewSpec]) {
        state.navigationPath = path
    }
    /// Pops to the root of the navigation stack.
    func popToRoot() {
        state.navigationPath = []
    }
    /// Presents a view as a sheet.
    func presentSheet(_ viewSpec: ViewSpec) {
        state.presentingSheet = viewSpec
    }
    /// Presents a view in full screen.
    func presentFullScreen(_ viewSpec: ViewSpec) {
        state.presentingFullScreen = viewSpec
    }
    /// Presents a view as a modal.
    func presentModal(_ viewSpec: ViewSpec) {
        state.presentingModal = viewSpec
    }
    /// Dismisses the topmost view or modal presentation.
    func dismiss() {
        if state.presentingSheet != nil {
            state.presentingSheet = nil
        } else if state.presentingFullScreen != nil {
            state.presentingFullScreen = nil
        } else if state.presentingModal != nil {
            state.presentingModal = nil
        } else if state.navigationPath.count > 0 {
            state.navigationPath.removeLast()
        } else {
            state.isPresented.wrappedValue = nil
        }
    }
    
}

extension Router {
    // Binding properties to the state's values, allowing SwiftUI views to bind to these values directly.
    var navigationPath: Binding<[ViewSpec]> {
        binding(keyPath: \.navigationPath)
    }
    
    var presentingSheet: Binding<ViewSpec?> {
        binding(keyPath: \.presentingSheet)
    }
    
    var presentingFullScreen: Binding<ViewSpec?> {
        binding(keyPath: \.presentingFullScreen)
    }
    
    var presentingModal: Binding<ViewSpec?> {
        binding(keyPath: \.presentingModal)
    }
    
    var isPresented: Binding<ViewSpec?> {
        state.isPresented
    }
    
    func hideTabBar() {
        isTabBarVisible = false
    }

    func showTabBar() {
        isTabBarVisible = true
    }
}

private extension Router {
    /// Creates a binding to a specific key path of the `State`.
    /// - Parameter keyPath: The key path of the state property to bind to.
    /// - Returns: A `Binding` to the specified state property.
    func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }
}
