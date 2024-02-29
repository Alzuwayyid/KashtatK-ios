//
//  ProductDetailsView.swift
//  KashtatK
//
//  Created by Mohammed on 29/02/2024.
//

import SwiftUI
import Neumorphic

struct ProductDetailsView: View {
    // MARK: Properities
    @EnvironmentObject var router: HomeRouter
    var neumorphicNavigationBarItems: [NavBarItem] = []
    var product: Hit?
    
    var body: some View {
        BaseView {
            VStack {
                NeumorphicNavigationBar(
                    items: neumorphicNavigationBarItems,
                    showBackButton: true,
                    title: product?.productName ?? "Product Name",
                    titleType: .subScreen,
                    onBack: {
                        router.dismiss()
                    }
                )
                ScrollView {
                    VStack(alignment: .leading) {
                        GradientBackgroundView(imageUrl: URL(string: product?.images ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Mobily_Logo.svg/800px-Mobily_Logo.svg.png")!)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product?.productName ?? "Product Name")
                                .font(.title)
                                .bold()
                            Text(product?.category ?? "Category")
                                .font(.title2)
                            Text("\(String(format: "%.2f", product?.price ?? 0)) SR")
                                .font(.subheadline)
                                .bold()
                            Text(product?.desc ?? "Essential gadgets to keep you connected and powered up, no matter how remote your camping spot.")
                                .font(.caption)
                        }
                        HStack(spacing: 70) {
                            NeumorphicCircleView(mode: .cart(counter: product?.stock ?? 0))
                                .padding()
                            NeumorphicCircleView(mode: .rating(value: product?.rating ?? 0.0), imageStr: "star.fill")
                                .padding()
                        }
                        .background(Color.Neumorphic.main.opacity(0.1))
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 16)
                Spacer()
                Button(action: {
                    // TODO: Save it to the Cart
                }) {
                    Text("Add to Cart").fontWeight(.bold).frame(maxWidth: .infinity)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: 15),
                                 mainColor: Color.orange, textColor: Color.white)
                    .padding(.horizontal, 32)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            router.hideTabBar()
        }
    }
}

// SwiftUI Preview
struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView()
            .previewLayout(.sizeThatFits)
    }
}
