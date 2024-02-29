//
//  ProductsListView+Views.swift
//  KashtatK
//
//  Created by Mohammed on 29/02/2024.
//

import SwiftUI
import Neumorphic
import SwiftData

struct ProductItem: View {
    // MARK: Properities
    var product: Hit?
    
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

