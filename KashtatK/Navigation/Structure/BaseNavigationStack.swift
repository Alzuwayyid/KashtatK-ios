//
//  BaseNavigationStack.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
/// `BaseNavigationStack` provides a customizable navigation stack container for SwiftUI views.
/// It integrates with a `Router` to manage navigation and presentation, supporting dynamic content,
/// custom navigation bar items, and styling options.
///
/// - Parameters:
///   - router: An instance of `Router` to manage navigation logic and state.
///   - title: The title to be displayed in the navigation bar.
///   - baseColor: The background color for the navigation bar and content area. Defaults to `.clear`.
///   - isHidden: A Boolean value indicating whether the navigation bar should be hidden. Defaults to `false`.
///   - content: A closure returning the `Content` view to be displayed as the root of the navigation stack.
///   - leftBarButton: An optional closure returning a custom view to be used as the left bar button item.
///   - rightBarButton: An optional closure returning a custom view to be used as the right bar button item.
///
/// The `BaseNavigationStack` struct is designed to be flexible, allowing developers to customize the navigation
/// experience through parameters and closures. It leverages SwiftUI's `NavigationStack` for navigation management,
/// while providing hooks for customizing the navigation bar and handling navigation actions dynamically through
/// the provided `Router` instance.
///
/// Usage example:
/// ```
/// BaseNavigationStack(router: Router, title: "Home") {
///     Text("Hello, world!")
///         .padding()
/// }
/// ```
struct BaseNavigationStack<Content: View>: View {
    @StateObject var router: Router
    
    var title: String
    var baseColor: SwiftUI.Color
    var isHidden: Bool = false
    var content: Content
    var leftBarButton: (() -> AnyView)?
    var rightBarButton: (() -> AnyView)?
    
    init(router: Router,
         title: String,
         baseColor: SwiftUI.Color = .clear,
         isLoading: Bool = false,
         isHidden: Bool = false,
         @ViewBuilder content: () -> Content,
         leftBarButton: (() -> AnyView)? = nil,
         rightBarButton: (() -> AnyView)? = nil) {
        _router = StateObject(wrappedValue: router )
        self.title = title
        self.baseColor = baseColor
        self.isHidden = isHidden
        self.content = content()
        self.leftBarButton = leftBarButton
        self.rightBarButton = rightBarButton
    }
    
    var body: some View {
        NavigationStack(path: router.navigationPath) {
            content
                .navigationBarTitle(title)
                .navigationBarHidden(isHidden)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(
                    self.baseColor,
                    for: .navigationBar)
                .navigationBarItems(
                    leading: leftBarButton?(),
                    trailing: rightBarButton?()
                )
                .navigationDestination(for: ViewSpec.self) { spec in
                    router.view(spec: spec, route: .navigation)
                }
        }
        .toolbarRole(.editor)
        .sheet(item: router.presentingSheet) { spec in
            router.view(spec: spec, route: .sheet)
        }.fullScreenCover(item: router.presentingFullScreen) { spec in
            router.view(spec: spec, route: .fullScreen)
        }
    }
}

