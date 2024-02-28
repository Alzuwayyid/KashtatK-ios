//
//  Views.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
import Neumorphic

extension View {
    /// Converts the invoking view to `AnyView` for type erasure.
    /// Useful for returning different types of views from a single function or when a view's type needs to be abstracted.
    func earseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

struct BaseView<Content: View>: View {
    let content: Content
    let baseColor: Color // Allows customization of the base color if needed

    init(baseColor: Color = Color.Neumorphic.main, @ViewBuilder content: () -> Content) {
        self.baseColor = baseColor
        self.content = content()
    }

    var body: some View {
        ZStack {
            baseColor.edgesIgnoringSafeArea(.all)
            content
        }
    }
}
