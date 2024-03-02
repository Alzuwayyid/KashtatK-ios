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
                    .font(.bodyFont40)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Discover seamless shopping with our cutting-edge app, designed for swift navigation and robust performance. 🚀")
                    .padding()
                    .font(.bodyFont24)
                
                Text("Features:")
                    .font(.bodyFont19)
                    .padding(.top)
                    .bold()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("✅ Robust Network Layer: Ensures reliable and fast data transfer. 🌐")
                        .font(.bodyFont15)
                    Text("✅ Advanced Navigation Stack: Navigate effortlessly through the app. 🧭")
                        .font(.bodyFont15)
                    Text("✅ Persistent Data Storage: Your shopping data stays safe and ready. 💾")
                        .font(.bodyFont15)
                    Text("✅ Diverse Product Listing: Explore a wide range of products with ease. 🛍️")
                        .font(.bodyFont15)
                    Text("✅ Detailed Product Insights: Get to know everything about your picks. 🔍")
                        .font(.bodyFont15)
                    Text("✅ Smart Filtering: Find products by category, trends, and popularity. 🔖")
                        .font(.bodyFont15)
                    Text("✅ Search & Auto-completion: Find what you need with smart suggestions. 🕵️‍♂️")
                        .font(.bodyFont15)
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}
