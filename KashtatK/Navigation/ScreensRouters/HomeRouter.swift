//
//  HomeRouter.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
/// `HomeRouter` is a subclass of `Router` designed to handle navigation specifically for the "Home" section of the application.
/// It extends the basic navigation functionalities provided by `Router` with additional capabilities tailored to the home context.
class HomeRouter: Router {
    func pushProductsList(with id: String = "", type: ProductsListView.ProductType = .all) {
        navigateTo(.productsList(id: id, type: type))
    }
    
    func pushSearchScreen() {
        navigateTo(.search)
    }
    
    func pushProductDetails(with hit: Hit) {
        navigateTo(.productDetails(with: hit))
    }
    
    /// Overrides the `view(spec:route:)` method to provide specific view instances based on `ViewSpec` and `Route`.
    /// This method should be used to return the actual view for the specified `ViewSpec` within the home navigation context.
    override func view(spec: ViewSpec, route: Router.Route) -> AnyView {
        AnyView(buildView(spec: spec, route: route).environmentObject(self))
    }
}

private extension HomeRouter {
    /// Builds and returns a SwiftUI view based on the provided `ViewSpec` and `Route`.
    /// - Parameters:
    ///   - spec: The `ViewSpec` that specifies which view to build.
    ///   - route: The `Route` that specifies how the view is to be presented.
    /// - Returns: A SwiftUI view corresponding to the given `ViewSpec` and presentation style.
    @ViewBuilder
    func buildView(spec: ViewSpec, route: Route) -> some View {
        switch spec {
            case .productsList(id: let id, type: let type):
                ProductsListView(productId: id, type: type)
            case .search:
                SearchView()
            case .productDetails(with: let hit):
                ProductDetailsView(product: hit)
            default:
                Text("").earseToAnyView()
        }
    }
}
