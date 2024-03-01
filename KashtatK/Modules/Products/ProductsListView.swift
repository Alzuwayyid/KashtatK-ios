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
    @State var contentState: ContentStates = ContentStates()
    @State private var selectedChipId: String?
    var neumorphicNavigationBarItems: [NavBarItem] = []
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    let layout = [GridItem(.flexible())]
    
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
                ZStack {
                    RoundedRectangle(cornerRadius: 15).fill(Color.Neumorphic.main).frame(height: 55).frame(maxWidth: .infinity)
                        .softInnerShadow(RoundedRectangle(cornerRadius: 15))
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: layout) {
                            ForEach(filterKeywords.first?.filterKeyWords ?? [], id: \.self) { keyword in
                                FilterChipView(data: keyword, isSelected: selectedChipId == keyword.id) { id in
                                    if selectedChipId == id {
                                        selectedChipId = nil  // Deselect if already selected
                                    } else {
                                        selectedChipId = id  // Select the chip
                                    }
                                    productId = id
                                    Task {
                                        await getProducts()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                        .frame(height: 55)
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(.horizontal, 16)
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
            print("Failed to delete all.")
        }
    }
}


