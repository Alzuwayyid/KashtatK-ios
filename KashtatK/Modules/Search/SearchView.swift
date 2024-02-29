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
    @FocusState var isTextFieldFouced
    @Query var savedSearch: [SearchModel]
    
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
                    BaseSearchView(text: $query, isTextFieldFocused: _isTextFieldFouced)
                        .padding(.horizontal, 16)
                    ForEach(savedSearch) { saved in
                        SearchItem(id: saved.searchedQueries, rightImage: "xmark") {
                            withAnimation {
                                context.delete(saved)
                            }
                        }
                        .onTapGesture {
                            router.pushProductsList(with: saved.searchedQueries)
                        }
                    }
                    .padding(.horizontal, 32)
                    if let hits = data?.hits{
                        ForEach(hits, id: \.id) { product in
                            SearchItem(id: product.productName) { }
                            .onTapGesture {
                                if isTextFieldFouced {
                                    saveSearchQuery()
                                }
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
            } catch {
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
    
    func saveSearchQuery() {
        context.insert(SearchModel.init(searchedQueries: query))
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
