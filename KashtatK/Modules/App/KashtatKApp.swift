//
//  KashtatKApp.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI
import SwiftData
import Neumorphic

@main
struct KashtatKApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [Products.self, Hit.self, HighlightResult.self, Category.self, SearchModel.self, FilterModel.self, CartModel.self, SearchKeywords.self, Trend.self])
    }
}

struct RootView: View {
    @State private var showSplash = true // Initially show the splash screen
    
    var body: some View {
        VStack {
            if showSplash {
                SplashScreenView()
            } else {
                TabViews()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 1)) {
                    self.showSplash = false
                }
            }
        }
    }
}

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image("appLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("KashtatK")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Neumorphic.main)
        .edgesIgnoringSafeArea(.all)
        .transition(.move(edge: .top)) // Slide out animation
    }
}
