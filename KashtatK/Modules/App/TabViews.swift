//
//  TabViews.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftUI
import Neumorphic
// Main view container for the tab views.
struct TabViews: View {
    // State variable to track the currently selected tab.
    @State private var selectedTab: Tab = .home
    @State private var isTabBarVisible: Bool = true
    @StateObject var homeRouter: HomeRouter
    @Environment(\.modelContext) var context
    
    init() {
        // Initialize the HomeRouter here with _isTabBarVisible directly
        let isPresented = Binding.constant(Tab.home)
        let isTabBarVisibleBinding = Binding.constant(true)
        // Initialize _homeRouter as a StateObject
        _homeRouter = StateObject(wrappedValue: HomeRouter(isPresented: .constant(.home)))
    }
    
    var body: some View {
        // BaseView is a custom container that could provide common styling or navigation.
        BaseView {
            VStack {
                // Switching the displayed content view based on the currently selected tab.
                switch selectedTab {
                case .home:
                        HomeView(homeRouter: homeRouter)
                            .environmentObject(homeRouter)
                case .settings:
                    SettingsView()
                }
                // The custom tab bar view at the bottom of the screen.
                if homeRouter.isTabBarVisible {
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }
        .onAppear {
            homeRouter.showTabBar()
            setupModels()
        }
    }
}

extension TabViews {
    private func setupModels() {
        deleteFilterData()
        let keyWords = [SearchKeywords(id: "", title: "All"), SearchKeywords(id: "Electronics", title: "Electronics"), SearchKeywords(id: "Lighting", title: "Lighting"), SearchKeywords(id: "Accessories", title: "Accessories"), SearchKeywords(id: "Cooking", title: "Cooking"), SearchKeywords(id: "Navigation", title: "Navigation"), SearchKeywords(id: "Hydration", title: "Hydration"), SearchKeywords(id: "Safety", title: "Safety")]
        let popularKeyWords = [SearchKeywords(id: "map and compass", title: "Map and Compass"), SearchKeywords(id: "tent", title: "Tent"), SearchKeywords(id: "sleeping bag", title: "Sleeping Bag"), SearchKeywords(id: "campfire grill", title: "Campfire Grill"), SearchKeywords(id: "portable stove", title: "Portable Stove"), SearchKeywords(id: "camping chair", title: "Camping Chair"), SearchKeywords(id: "LED lantern", title: "LED lantern"), SearchKeywords(id: "water bottle", title: "Water bottle"), SearchKeywords(id: "first aid kit", title: "First Aid kit")]
        let trends = [Trend(id: "Portable", title: "Portable", imageUrl: "https://shorturl.at/HLU17"),
                      Trend(id: "Eco-Friendly", title: "Eco-Friendly", imageUrl: "https://shorturl.at/cw178"),
                      Trend(id: "Family Camping", title: "Family Camping", imageUrl: "https://shorturl.at/dGL03"),
                      Trend(id: "Navigation", title: "Navigation", imageUrl: "https://shorturl.at/giCMV"),
                      Trend(id: "Essential", title: "Essential", imageUrl: "https://shorturl.at/DPWZ0"),
                      Trend(id: "Comfort", title: "Comfort", imageUrl: "https://m.media-amazon.com/images/I/51QTeGQjOuL._AC_SL1100_.jpg"),
                      Trend(id: "Hydration", title: "Hydration", imageUrl: "https://m.media-amazon.com/images/I/61Cfw1rApBL.jpg"),
        ]
        let filters = FilterModel(popularSearches: popularKeyWords, trends: trends, filterKeyWords: keyWords)
        context.insert(filters)
    }
    
    func deleteFilterData() {
        do {
            try context.delete(model: FilterModel.self)
        } catch {
            print("Failed to delete all.")
        }
    }
}
// Enumeration to define the tabs available in the application.
enum Tab {
    case home, settings
}

// Custom tab bar view to allow users to switch between tabs.
struct CustomTabBar: View {
    // Binding to the selected tab state in the parent view.
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack(spacing: 0) {
            // A line at the top of the tab bar with a shadow for visual separation.
            Rectangle()
                .fill(Color.gray.opacity(0.2)) // Semi-transparent gray color for the line.
                .frame(height: 1)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 10)
            
            // Container for tab buttons.
            HStack(spacing: 10) {
                // Home tab button.
                tabButton(for: .home, iconName: "house.fill", label: "Home")
                    .padding(.leading, 60)
                
                // Flexible space to separate the buttons.
                Spacer()
                
                // Settings tab button.
                tabButton(for: .settings, iconName: "gearshape.fill", label: "Settings")
                    .padding(.trailing, 60)
            }
            .padding(.top, 15)
            .background(Color.Neumorphic.main) // Applying neumorphic style background.
        }
        .frame(height: 100) // Fixed height for the tab bar.
    }

    // Function to create a tab button.
    private func tabButton(for tab: Tab, iconName: String, label: String) -> some View {
        Button(action: {
            // Action to switch tabs.
            selectedTab = tab
        }) {
            VStack {
                // The icon of the tab button.
                Image(systemName: iconName)
                    .foregroundColor(selectedTab == tab ? .blue : .gray) // Highlight if selected.
                    .frame(height: 20)
            }
        }
        .softButtonStyle(RoundedRectangle(cornerRadius: 15)) // Applying neumorphic style to the button.
    }
}


struct SettingsView: View {
    @State private var showBackButton = true
    var body: some View {
        // Your Settings view content here
        VStack {
            NeumorphicNavigationBar(
                items: [
                    NavBarItem(icon: Image(systemName: "house.fill"), mainColor: Color.white, secondaryColor: Color.blue) { print("Home tapped") },
                    NavBarItem(icon: Image(systemName: "person.fill"), mainColor: Color.white, secondaryColor: Color.blue) { print("Profile tapped") }
                ],
                showBackButton: showBackButton, title: "Settings",
                titleType: .main,
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

