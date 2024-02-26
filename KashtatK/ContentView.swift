//
//  ContentView.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeRouter = HomeRouter(isPresented: .constant(.home))
    
    var body: some View {
        BaseNavigationStack(router: homeRouter, title: "Home") {
            Text("Hello, world!")
                .padding()
                .onTapGesture {
                    homeRouter.pushProductsList()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
