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
    @StateObject var homeRouter = HomeRouter(isPresented: .constant(.home))
    @Environment(\.modelContext) var context
    @State var contentState: ContentStates = ContentStates()
    @Query var data: [Products]
    @State private var showBackButton = true
    
    var body: some View {
        BaseNavigationStack(router: homeRouter, title: "Home", baseColor: Color.Neumorphic.main) {
            ZStack {
                Color.Neumorphic.main.edgesIgnoringSafeArea(.all)
            }
            .overlay(
                NeumorphicNavigationBar(
                    items: [
                        NavBarItem(icon: Image(systemName: "house.fill")) { print("Home tapped") },
                        NavBarItem(icon: Image(systemName: "person.fill")) { print("Profile tapped") }
                    ],
                    showBackButton: showBackButton,
                    onBack: {
                        showBackButton = false
                    }
                )
                .padding(.horizontal, 16),
                alignment: .top // Align the navigation bar to the top
            )
        }
        .onAppear {
            Task {
//                await getProducts()
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

