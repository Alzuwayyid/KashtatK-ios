//
//  ContentView.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
import Combine
import SwiftData

struct ContentView: View {
    @StateObject var homeRouter = HomeRouter(isPresented: .constant(.home))
    var products: Products?
    @Environment(\.modelContext) var context
    @State var apiError: APIError?
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
                await getAsyncEvents()
            }
        }
    }
}

extension ContentView {
    @MainActor
    func getAsyncEvents() async {
        let endpoint = Endpoints.getProductsByPopular(id: "tent")
        Task {
            do {
                let events = try await APITask.shared.asyncRequest(endpoint: endpoint, responseModel: Products.self)
                do {
                    context.insert(events)
                    try context.save()
                } catch {
                    print("Core Data Error: \(error.localizedDescription)")
                }
            } catch let error as APIError {
                apiError = error
            } catch {
                print("Unexpected error: \(error.localizedDescription)")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
