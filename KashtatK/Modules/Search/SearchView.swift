//
//  SearchView.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftUI
import Neumorphic
import SwiftData

struct SearchView: View {
    // MARK: Properties
    @EnvironmentObject var router: HomeRouter
    @Environment(\.modelContext) var context
    var neumorphicNavigationBarItems: [NavBarItem] = []
    @State var data: ProductObjectModel?
    @State var contentState: ContentStates = ContentStates()
    @State var query: String = ""
    
    var body: some View {
        VStack {
            NeumorphicNavigationBar(
                items: neumorphicNavigationBarItems,
                showBackButton: true,
                title: "Search",
                titleType: .subScreen,
                onBack: {
                    router.dismiss()
                    withAnimation {
                        router.showTabBar()
                    }
                }
            )
            ScrollView {
                VStack(spacing: 25) {
                    BaseSearchView(text: $query)
                        .padding(.horizontal, 16)
                    if let hits = data?.hits{
                        ForEach(hits, id: \.id) { product in
                            SearchItem(id: product.productName) { }
                            .onTapGesture {
                                router.pushProductsList(with: product.productName)
                            }
                        }
                        .padding(.horizontal, 32)
                    }
                }
            }
            Spacer()
        }
        .onChange(of: query) { oldVal, newVal in
            Task {
                await getProducts()
            }
        }
        .onAppear {
            router.hideTabBar()
        }
        .background(Color.Neumorphic.main)
        .navigationBarBackButtonHidden()
    }
    
}
// MARK: API Calls
extension SearchView {
    @MainActor
    func getProducts() async {
        Task {
            do {
                let loadedProducts = try await HomeServices.getProducts(by: query)
                data = loadedProducts
//                context.insert(loadedProducts)
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
//        SearchView()
//            .previewLayout(.sizeThatFits)
//    }
//}

struct SearchItem: View {
    // MARK: Properities
    var id: String
    var leftImage = "magnifyingglass"
    var rightImage = "arrow.up.right.square"
    var action: () -> ()
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: leftImage)
                Text(id)
            }
            Spacer()
            Image(systemName: rightImage)
                .onTapGesture {
                    action()
            }
        }
    }
}
