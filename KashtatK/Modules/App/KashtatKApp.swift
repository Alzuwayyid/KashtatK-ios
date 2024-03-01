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
            TabViews()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [Products.self, Hit.self, HighlightResult.self, Category.self, SearchModel.self, FilterModel.self, SearchKeywords.self])
    }
}
