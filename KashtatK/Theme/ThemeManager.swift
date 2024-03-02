//
//  ThemeManager.swift
//  KashtatK
//
//  Created by Mohammed on 26/02/2024.
//

import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    var gridFixed55: [GridItem] = [GridItem(.fixed(55))]
    var GridItemFlexcolumns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
}
