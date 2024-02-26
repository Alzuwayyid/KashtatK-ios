//
//  Views.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI

extension View {
    /// Converts the invoking view to `AnyView` for type erasure.
    /// Useful for returning different types of views from a single function or when a view's type needs to be abstracted.
    func earseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
