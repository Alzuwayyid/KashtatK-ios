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
    var productId: String
    @Environment(\.modelContext) var context
    @EnvironmentObject var router: HomeRouter
    @Query var data: [Products]
    @State var contentState: ContentStates = ContentStates()
    var neumorphicNavigationBarItems: [NavBarItem] = []
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        BaseView {
            VStack {
                NeumorphicNavigationBar(
                    items: neumorphicNavigationBarItems,
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
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(data.first?.hits ?? []) { product in
                            ProductItem(product: product)
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
        .onAppear {
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
            print("Failed to delete all schools.")
        }
    }
}
