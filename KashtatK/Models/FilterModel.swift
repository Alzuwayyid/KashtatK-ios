//
//  FilterModel.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftData

@Model
class FilterModel {
    var popularSearches: [String]
    var trends: [String]
    var filterKeyWords: [String]
    
    init(popularSearches: [String], trends: [String], filterKeyWords: [String]) {
        self.popularSearches = popularSearches
        self.trends = trends
        self.filterKeyWords = filterKeyWords
    }
}


