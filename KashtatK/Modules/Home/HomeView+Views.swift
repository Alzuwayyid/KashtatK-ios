//
//  HomeView+Views.swift
//  KashtatK
//
//  Created by Mohammed on 02/03/2024.
//

import SwiftUI
import Neumorphic

struct CartStateComponentView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5).fill(Color.Neumorphic.main).frame(height: 140).frame(maxWidth: .infinity)
                .softInnerShadow(RoundedRectangle(cornerRadius: 5))
            VStack(spacing: 10) {
                Text("No items added to the bag")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.black.opacity(0.6))
                Image(systemName: "cross.fill")
                    .foregroundStyle(Color.black.opacity(0.6))
            }
            .padding()
        }
    }
}

struct LongComponentView: View {
    // MARK: Properties
    var items: [FilterModel]
    let didSelect: (String?) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).fill(Color.Neumorphic.main).frame(height: 220).frame(maxWidth: .infinity)
                .softInnerShadow(RoundedRectangle(cornerRadius: 15))
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: ThemeManager.shared.gridFixed55) {
                    ForEach(items.flatMap { $0.trends }, id: \.id) { keyword in
                        TrendingProductView(imageUrl: keyword.imageUrl, text: keyword.title)
                            .onTapGesture {
                                didSelect(keyword.id)
                            }
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}


struct TrendingProductView: View {
    var imageUrl: String
    var text: String
    
    var body: some View {
        ZStack {
            // Image
            BaseAsyncImage(url: imageUrl, height: 190, width: 190, isScaleToFill: true)
                .frame(width: 190, height: 190)
                .clipped()
            
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]), startPoint: .center, endPoint: .bottom)
            
            // Text
            Text(text)
                .bold()
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.leading, 30)
                .padding(.bottom , 10)

        }
        .frame(width: 150, height: 190)
        .cornerRadius(2.5)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
        .background(Color.Neumorphic.main)
    }
}
