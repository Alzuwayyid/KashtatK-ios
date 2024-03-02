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
    @State private var showBackButton = true
    @State var contentState: ContentStates = ContentStates()
    @State var text: String = ""
    var body: some View {
        BaseNavigationStack(router: homeRouter, title: "") {
            VStack {
                NeumorphicNavigationBar(
                    items: [
                        NavBarItem(icon: Image(systemName: "cart.fill"), mainColor: Color.white, secondaryColor: Color.blue) {
                            print("Home tapped")
                            homeRouter.pushProductsList()
                        },
                        NavBarItem(icon: Image(systemName: "cross.fill"), mainColor: Color.white, secondaryColor: Color.green) {
                            
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
