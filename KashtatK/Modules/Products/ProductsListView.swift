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
    enum ProductType {
        case all, popular, trend
    }
    
    // MARK: Properities
    @State var productId: String
    @Environment(\.modelContext) var context
    @EnvironmentObject var router: HomeRouter
    @Query var data: [Products]
    @Query var filterKeywords: [FilterModel]
    @Query var cartData: [CartModel]
    @State var contentState: ContentStates = ContentStates()
    @State private var selectedChipId: String?
    var type: ProductType = .all
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
                if type == .all {
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
                }
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
                .loading(isLoading: contentState.isLoading)
                Spacer()
            }
            
        }
        .onLoad {
            router.hideTabBar()
            Task {
                switch type {
                    case .all:
                        await getProducts()
                    case .popular:
                        await getPopularProducts()
                    case .trend:
                        await getTrendProducts()
                }
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
                    contentState.isLoading = true
                    let loadedProducts = try await HomeServices.getProducts()
                    deleteData()
                    context.insert(loadedProducts)
                    contentState.isLoading = false
                } else {
                    contentState.isLoading = true
                    let loadedProducts = try await HomeServices.getProducts(with: productId)
                    deleteData()
                    context.insert(loadedProducts)
                    contentState.isLoading = false
                }
            } catch {
                contentState.isLoading = false
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
    @MainActor
    func getPopularProducts() async {
        Task {
            do {
                contentState.isLoading = true
                let loadedProducts = try await HomeServices.getPopularProducts(for: productId)
                deleteData()
                context.insert(loadedProducts)
                contentState.isLoading = false
            } catch {
                contentState.isLoading = false
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
    @MainActor
    func getTrendProducts() async {
        Task {
            do {
                contentState.isLoading = true
                let loadedProducts = try await HomeServices.getTrendProducts(for: productId)
                deleteData()
                context.insert(loadedProducts)
                contentState.isLoading = false
            } catch {
                contentState.isLoading = false
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
}
// MARK: Models
extension ProductsListView {
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


