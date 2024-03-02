//
//  ProductsListView+Views.swift
//  KashtatK
//
//  Created by Mohammed on 29/02/2024.
//

import SwiftUI
import Neumorphic
import SwiftData

// MARK: Product Item
struct ProductItem: View {
    // MARK: Properities
    var product: Hit?
    var didAddToCart: () -> ()
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle().fill(Color.Neumorphic.main).frame(width: 170, height: 205)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .softOuterShadow()
            VStack(alignment: .leading, spacing: 4) {
                BaseAsyncImage(url: product?.images ?? "")
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .frame(width: 120, height: 90)
                Text(product?.productName ?? "Product")
                    .frame(width: 130, alignment: .leading)
                    .font(.system(size: 14))
                    .bold()
                    .lineLimit(1)
                Text("\(String(format: "%.2f", product?.price ?? 0)) SR")
                    .font(.system(size: 12))
                Button(action: {
                    didAddToCart()
                }) {
                    HStack {
                        Text("Add to cart")
                            .font(.system(size: 12))
                            .bold()
                            .foregroundColor(Color.white)
                    }
                }.softButtonStyle(Rectangle(), mainColor: Color.green, textColor: Color.white, darkShadowColor: Color.Neumorphic.darkShadow, lightShadowColor:Color.Neumorphic.lightShadow)
                    .frame(width: 100, height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(.top, 2)
            }
            .padding(.horizontal, 20)
        }
    }
}
// MARK: Filter Chip View
struct FilterChipView: View {
    // MARK: Properties
    let data: SearchKeywords
    var isSelected: Bool
    var cornerRadius: CGFloat = 20
    let onTap: (_ id: String) -> ()
    
    var body: some View {
        Text(data.title)
            .foregroundStyle(Color.black.opacity(0.5))
            .padding(10)
            .background(isSelected ? Color.gray : Color.Neumorphic.main)
            .cornerRadius(cornerRadius)
            .shadow(color: isSelected ? .gray : .black.opacity(0.5), radius: 0.5, x: 0.5, y: 0.5)
            .shadow(color: isSelected ? .white : .clear, radius: 0.5, x: -0.5, y: -0.5)
            .onTapGesture {
                self.onTap(data.id)
            }
    }
}
