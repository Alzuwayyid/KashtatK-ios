//
//  InfoView.swift
//  KashtatK
//
//  Created by Mohammed on 02/03/2024.
//

import SwiftUI

struct InfoView: View {
    @State private var showBackButton = true
    
    var body: some View {
        VStack {
            ScrollView {
                Text("🔧 App Info")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Discover seamless shopping with our cutting-edge app, designed for swift navigation and robust performance. 🚀")
                    .padding()
                    .font(.headline)
                
                Text("Features:")
                    .font(.title2)
                    .padding(.top)
                    .bold()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("✅ Robust Network Layer: Ensures reliable and fast data transfer. 🌐")
                    Text("✅ Advanced Navigation Stack: Navigate effortlessly through the app. 🧭")
                    Text("✅ Persistent Data Storage: Your shopping data stays safe and ready. 💾")
                    Text("✅ Diverse Product Listing: Explore a wide range of products with ease. 🛍️")
                    Text("✅ Detailed Product Insights: Get to know everything about your picks. 🔍")
                    Text("✅ Smart Filtering: Find products by category, trends, and popularity. 🔖")
                    Text("✅ Search & Auto-completion: Find what you need with smart suggestions. 🕵️‍♂️")
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}
