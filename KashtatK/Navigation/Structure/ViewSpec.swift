//
//  ViewSpec.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
/// `ViewSpec` defines specific views that can be navigated within the application.
/// It serves as a strongly-typed enumeration of all views that are part of the navigation flow.
enum ViewSpec {
    case home, productsList, search, productDetails(with: Hit)
}

extension ViewSpec: Identifiable {
    /// Provides a unique identifier for each `ViewSpec`. This is necessary for SwiftUI's navigation and list management,
    /// allowing SwiftUI to differentiate between views, especially when used in a navigation stack or list.
    var id: Int {
        switch self {
            case .home:
                return 1
            case .productsList:
                return 2
            case .search:
                return 3
            case .productDetails:
                return 4
        }
    }
}

extension ViewSpec: Equatable {
    static func == (lhs: ViewSpec, rhs: ViewSpec) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ViewSpec: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
