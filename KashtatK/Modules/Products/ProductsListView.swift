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
    @Environment(\.modelContext) var context
    @EnvironmentObject var router: HomeRouter
    @Query var data: [Products]
    @State var contentState: ContentStates = ContentStates()
    var neumorphicNavigationBarItems: [NavBarItem] = []
    private var columns: [GridItem] = [
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
                        router.dismiss()
                    }
                )
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(data.first?.hits ?? []) { product in
                            ProductItem(product: product)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            
        }
        .onAppear {
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
                let loadedProducts = try await HomeServices.getProducts()
                context.insert(loadedProducts)
                try context.save()
            } catch {
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
}

//// SwiftUI Preview
//struct ProductsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductsListView()
//            .previewLayout(.sizeThatFits)
//    }
//}
