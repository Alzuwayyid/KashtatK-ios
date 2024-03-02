//
//  ContentView.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
import Combine
import SwiftData
import Neumorphic

struct HomeView: View {
    // MARK: Properities
    @StateObject var homeRouter: HomeRouter
    @Environment(\.modelContext) var context
    @Query var data: [Products]
    @Query var cartData: [CartModel]
    @Query var filterKeywords: [FilterModel]
    @State private var showBackButton = true
    @State var contentState: ContentStates = ContentStates()
    @State var text: String = ""
    
    var body: some View {
        BaseNavigationStack(router: homeRouter, title: "") {
            VStack {
                NeumorphicNavigationBar(
                    items: [
                        NavBarItem(icon: Image(systemName: "cart.fill"), mainColor: Color.white, secondaryColor: Color.blue, counter: cartData.count) { },
                        NavBarItem(icon: Image(systemName: "cross.fill"), mainColor: Color.white, secondaryColor: Color.green, counter: nil) {
                            homeRouter.pushProductsList()
                        } ],
                    showBackButton: false,
                    title: "Home",
                    titleType: .main
                )
                ZStack(alignment: .top) {
                    Color.Neumorphic.main.ignoresSafeArea()
                    VStack(spacing: 40) {
                        SearchBarView {
                            homeRouter.pushSearchScreen()
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Popular Searches")
                                .foregroundStyle(Color.black.opacity(0.5))
                                .font(.bodyFont20)
                            FilterKeywordsScrollView(filterKeywords: filterKeywords, keywordsType: .popularSearches, cornerRadius: 6, horizontalPadding: 12, onChipSelected: { id in
                                homeRouter.pushProductsList(with: id ?? "", type: .popular)
                            })
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Trending")
                                .font(.bodyFont20)
                                .foregroundStyle(Color.black.opacity(0.5))
                            LongComponentView(items: filterKeywords) { id in
                                homeRouter.pushProductsList(with: id ?? "", type: .trend)
                            }
                            .frame(height: 210)
                        }
                        if cartData.isEmpty {
                            CartStateComponentView()
                                .onTapGesture {
                                    homeRouter.pushProductsList()
                                }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
// MARK: API Calls
extension HomeView {
    @MainActor
    func getProducts() async {
        Task {
            do {
                let loadedProducts = try await HomeServices.getPopularProducts(for: "tent")
                context.insert(loadedProducts)
                try context.save()
            } catch {
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
}
