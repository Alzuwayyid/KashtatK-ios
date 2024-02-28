//
//  TabViews.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftUI

struct TabViews: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        BaseView {
            VStack(spacing: 0) {
                // Content based on selected tab
                switch selectedTab {
                case .home:
                    HomeView()
                case .settings:
                    SettingsView()
                }
                
                // Custom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
            }
        }
    }
}

enum Tab {
    case home, settings
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            // Home tab button
            tabButton(for: .home, iconName: "house.fill", label: "Home")
            
            Spacer()
            
            // Settings tab button
            tabButton(for: .settings, iconName: "gearshape.fill", label: "Settings")
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .background(Color(UIColor.systemGray6)) // Neumorphism background
        .cornerRadius(20)
        .shadow(color: .white, radius: 8, x: -8, y: -8) // Light source shadow
        .shadow(color: .gray, radius: 8, x: 8, y: 8) // Dark source shadow
        .padding(.horizontal)
        .frame(height: 88)
    }
    
    private func tabButton(for tab: Tab, iconName: String, label: String) -> some View {
        Button(action: {
            self.selectedTab = tab
        }) {
            VStack {
                Image(systemName: iconName)
                    .font(.title)
                Text(label)
                    .font(.caption)
            }
            .padding(.vertical, 8)
            .foregroundColor(self.selectedTab == tab ? .blue : .gray)
        }
    }
}

struct SettingsView: View {
    @State private var showBackButton = true
    var body: some View {
        // Your Settings view content here
        VStack {
            NeumorphicNavigationBar(
                items: [
                    NavBarItem(icon: Image(systemName: "house.fill")) { print("Home tapped") },
                    NavBarItem(icon: Image(systemName: "person.fill")) { print("Profile tapped") }
                ],
                showBackButton: showBackButton,
                onBack: {
                    // Handle back navigation
                    showBackButton = false
                    // Pop view from your custom navigation stack here
                }
            )
            Text("Settings View").frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

