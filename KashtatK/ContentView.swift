//
//  ContentView.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var homeRouter = HomeRouter(isPresented: .constant(.home))
    @State var products: Products?
    @State var apiError: APIError?
    private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        BaseNavigationStack(router: homeRouter, title: "Home") {
            Text("Hello, world!")
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
        let endpoint = Endpoints.getProducts
        Task.init {
            do {
                let events = try await APITask.shared.asyncRequest(endpoint: endpoint, responseModel: Products.self)
                products = events
            } catch let error as APIError {
                apiError = error
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
