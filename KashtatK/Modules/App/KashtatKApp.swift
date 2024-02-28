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
        }
        .modelContainer(for: [Products.self])
    }
}
