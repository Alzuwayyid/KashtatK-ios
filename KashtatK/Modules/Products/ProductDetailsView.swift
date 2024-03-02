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
    @Environment(\.modelContext) var context
    @State private var showSuccessBanner = false
    var product: Hit?
    
    var body: some View {
        BaseView {
            VStack {
                NeumorphicNavigationBar(
                    items: [],
                    showBackButton: true,
                    title: product?.productName ?? "Product Name",
                    titleType: .subScreen,
                    onBack: {
                        router.dismiss()
                    }
                )
                ScrollView {
                    VStack(alignment: .leading) {
                        GradientBackgroundView(imageUrl: URL(string: product?.images ?? "")!)
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        VStack(alignment: .leading, spacing: 5) {
                            Text(product?.productName ?? "Product Name")
                                .font(.bodyFont35)
                                .bold()
                            Text(product?.category ?? "Category")
                                .font(.bodyFont24)
                            Text("\(String(format: "%.2f", product?.price ?? 0)) SR")
                                .font(.bodyFont14)
                                .bold()
                            Text(product?.desc ?? "Essential gadgets to keep you connected and powered up, no matter how remote your camping spot.")
                                .font(.bodyFont12)
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
                    addToCart()
                    showSuccessBanner = true
                }) {
                    Text("Add to Cart").fontWeight(.bold).frame(maxWidth: .infinity)
                        .font(.bodyFont16)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: 15),
                                 mainColor: Color.orange, textColor: Color.white)
                .padding(.horizontal, 32)
                Spacer()
            }
        }
        .toastBanner(message: "Added Successfully to the Cart", status: .success, show: $showSuccessBanner)
        .navigationBarBackButtonHidden()
        .onAppear {
            router.hideTabBar()
        }
    }
}
// MARK: Helper method
extension ProductDetailsView {
    func addToCart() {
        let cart = CartModel(product: product)
        context.insert(cart)
        do {
            try context.save()
        } catch {
            print("Failed to save cart.")
        }
    }
}
