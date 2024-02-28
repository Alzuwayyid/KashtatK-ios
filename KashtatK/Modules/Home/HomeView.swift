//
//  ContentView.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
import Combine
import SwiftData

struct HomeView: View {
    @StateObject var homeRouter = HomeRouter(isPresented: .constant(.home))
    @Environment(\.modelContext) var context
    @State var contentState: ContentStates = ContentStates()
    @Query var data: [Products]
    
    var body: some View {
        BaseNavigationStack(router: homeRouter, title: "Home") {
            Text("Hello, world! -> \(data.first?.hits.first?.productName ?? "GG")")
                .padding()
                .onTapGesture {
                    homeRouter.pushProductsList()
                }
        }
        .onAppear {
            Task {
                await getProducts()
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

