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
    enum TitleType {
        case main, subScreen
    }
    // MARK: Properties
    var items: [NavBarItem]
    var showBackButton: Bool
    var title: String
    var titleType: TitleType
    var onBack: (() -> Void)?

    var body: some View {
        ZStack {
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
            }
            // Title positioned absolutely in the center
            Text(title)
                .bold()
                .font(.system(size: titleType == .main ? 40 : 20)) // Conditional font size
                .frame(maxWidth: .infinity, alignment: titleType == .main ? .leading : .center)
            HStack {
                Spacer()
                ForEach(items, id: \.id) { item in
                    Button(action: {
                        item.action()
                    }) {
                        item.icon
                    }
                    .softButtonStyle(Circle(), mainColor: item.mainColor, textColor: item.secondaryColor, darkShadowColor: Color.Neumorphic.darkShadow, lightShadowColor: Color.Neumorphic.lightShadow)
                }
            }
        }
        .padding()
        .background(Color.Neumorphic.main)
        .cornerRadius(10)
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
    let mainColor: Color
    let secondaryColor: Color
    let action: () -> Void
}

struct SearchBarView: View {
    // MARK: Properities
    var action: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.Neumorphic.secondary).font(Font.body.weight(.bold))
                Text("Search ...").foregroundColor(.Neumorphic.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: .Neumorphic.darkShadow, lightShadow: .Neumorphic.lightShadow, spread: 0.05, radius: 2)
            ).onTapGesture {
                action()
            }
        }
    }
}

struct BaseAsyncImage: View {
    // MARK: Properities
    let url: String
    var height: CGFloat = 90
    var width: CGFloat = 90
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
                 .scaledToFit()
                 .frame(width: width, height: height) 
        } placeholder: {
            ProgressView()
        }
    }
}
