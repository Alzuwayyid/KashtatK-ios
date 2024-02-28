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
    @StateObject var homeRouter = HomeRouter(isPresented: .constant(.home))
    @Environment(\.modelContext) var context
    @Query var data: [Products]
    @State private var showBackButton = true
    @State var contentState: ContentStates = ContentStates()
    @State var text: String = ""
    
    var body: some View {
        BaseNavigationStack(router: homeRouter, title: "Home", neumorphicNavigationBarItems: [
            NavBarItem(icon: Image(systemName: "heart.fill"), mainColor: Color.white, secondaryColor: Color.blue) {
                print("Home tapped")
                homeRouter.pushProductsList()
            },
            NavBarItem(icon: Image(systemName: "cross.fill"), mainColor: Color.white, secondaryColor: Color.green) {
                print("Profile tapped")
                homeRouter.pushProductsList()
            } ]) {
                ZStack(alignment: .top) {
                    Color.Neumorphic.main.ignoresSafeArea()
                        SearchView()
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 30).fill(Color.Neumorphic.main)
                                    .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: .Neumorphic.darkShadow, lightShadow: .Neumorphic.lightShadow, spread: 0.05, radius: 2)
                            ).onTapGesture {
                                print("SEARCHHH")
                            }
                        Spacer()
                        .padding(.bottom, 0)
                }
                .padding(.horizontal, 16)
            }
            .onAppear {
                Task {
//                    await getProducts()
                }
            }
    }
}
// MARK: API Calls
extension HomeView {
    @MainActor
    func getProducts() async {
        Task {
            do {
                let loadedProducts = try await HomeServices.getProducts(for: "tent")
                context.insert(loadedProducts)
                try context.save()
            } catch {
                print("Error: \(error.localizedDescription)")
                contentState.errorModel = .init(errorMessage: error.localizedDescription)
            }
        }
    }
}
