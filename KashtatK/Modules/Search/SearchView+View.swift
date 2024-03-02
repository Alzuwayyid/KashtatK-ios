//
//  SearchView+View.swift
//  KashtatK
//
//  Created by Mohammed on 02/03/2024.
//

import SwiftUI
// MARK: Search Item
struct SearchItem: View {
    // MARK: Properities
    var id: String
    var leftImage = "magnifyingglass"
    var rightImage = "arrow.up.right.square"
    var action: () -> ()
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: leftImage)
                Text(id)
                    .font(.bodyFont16)
            }
            Spacer()
            Image(systemName: rightImage)
                .onTapGesture {
                    action()
                }
        }
    }
}
// MARK: Search Bar
struct SearchBarView: View {
    // MARK: Properities
    var action: () -> ()
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.Neumorphic.secondary).font(Font.body.weight(.bold))
                Text("Search ...").foregroundColor(.Neumorphic.secondary)
                    .font(.bodyFont19)
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
// MARK: Base Search Bar
struct BaseSearchView: View {
    // MARK: Properities
    @Binding var text: String
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.Neumorphic.secondary).font(Font.body.weight(.bold))
                TextField("Search ...", text: $text)
                    .font(.bodyFont19)
                    .focused($isTextFieldFocused)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: .Neumorphic.darkShadow, lightShadow: .Neumorphic.lightShadow, spread: 0.05, radius: 2)
            )
        }
    }
}
