//
//  ProductsListView.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftUI
import Neumorphic
import SwiftData

struct ProductsListView: View {
    // MARK: Properities
    @State var productId: String
    @Environment(\.modelContext) var context
    @EnvironmentObject var router: HomeRouter
    @Query var data: [Products]
    @Query var filterKeywords: [FilterModel]
    @Query var cartData: [CartModel]
    @State var contentState: ContentStates = ContentStates()
    @State private var selectedChipId: String?
    var neumorphicNavigationBarItems: [NavBarItem] = []
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        BaseView {
            VStack {
                NeumorphicNavigationBar(
                    items: [NavBarItem(icon: Image(systemName: "cart.fill"), mainColor: Color.white, secondaryColor: Color.blue, counter: cartData.count) {
                        print("Home tapped")
                    }],
                    showBackButton: true,
                    title: "Products",
                    titleType: .subScreen,
                    onBack: {
                        withAnimation {
                            router.dismiss()
                            router.showTabBar()
                        }
                    }
                )
                FilterKeywordsScrollView(filterKeywords: filterKeywords, keywordsType: .filterKeyWords, onChipSelected: { id in
                    if selectedChipId == id {
                        selectedChipId = nil
                    } else {
                        selectedChipId = id
                    }
                    productId = id ?? ""
                    Task {
                        await getProducts()
                    }
                })
                .padding(.horizontal, 16)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(data.first?.hits ?? []) { product in
                            ProductItem(product: product) {
                                addToCart(with: product)
                            }
                                .onTapGesture {
                                    router.pushProductDetails(with: product)
                                }
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            
        }
        .onLoad {
            router.hideTabBar()
            Task {
                await getProducts()
            }
        }
        .navigationBarBackButtonHidden()
    }
}
// MARK: API Calls
extension ProductsListView {
    @MainActor
    func getProducts() async {
        Task {
            do {
                if productId.isEmpty {
                    let loadedProducts = try await HomeServices.getProducts()
                    deleteData()
                    context.insert(loadedProducts)
                } else {
                    let loadedProducts = try await HomeServices.getProducts(with: productId)
                    deleteData()
                    context.insert(loadedProducts)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func deleteData() {
        do {
            try context.delete(model: Products.self)
        } catch {
            print("Failed to delete all.")
        }
    }
    
    func addToCart(with product: Hit) {
        let cart = CartModel(product: product)
        context.insert(cart)
        do {
            try context.save()
        } catch {
            print("Failed to save cart.")
        }
    }
}


