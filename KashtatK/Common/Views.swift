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

struct NeumorphicNavigationBar: View {
    var items: [NavBarItem]
    var showBackButton: Bool
    var onBack: (() -> Void)?

    var body: some View {
        HStack {
            if showBackButton {
                Button(action: {
                    onBack?()
                }) {
                    Image(systemName: "chevron.left") // Example back button
                        .neumorphicStyle()
                }
            }
            
            Spacer()
            
            ForEach(items, id: \.id) { item in
                Button(action: {
                    item.action()
                }) {
                    item.icon
                        .neumorphicStyle()
                }
            }
        }
        .padding()
        .background(Color.Neumorphic.main)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
        .shadow(color: .white.opacity(0.7), radius: 5, x: -5, y: -5)
    }
}

extension View {
    func neumorphicStyle() -> some View {
        self
            .foregroundColor(Color.gray)
            .padding()
            .background(Color.Neumorphic.main)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
            .shadow(color: .white.opacity(0.7), radius: 2, x: -2, y: -2)
    }
}

struct NavBarItem {
    let id: UUID = UUID()
    let icon: Image
    let action: () -> Void
}
