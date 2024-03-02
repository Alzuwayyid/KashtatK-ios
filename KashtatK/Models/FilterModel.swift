//
//  FilterModel.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftData

@Model
class FilterModel {
    var popularSearches: [SearchKeywords]
    var trends: [String]
    var filterKeyWords: [SearchKeywords]
    
    init(popularSearches: [SearchKeywords], trends: [String], filterKeyWords: [SearchKeywords]) {
        self.popularSearches = popularSearches
        self.trends = trends
        self.filterKeyWords = filterKeyWords
    }
}

@Model
class SearchKeywords {
    var id: String
    var title: String
    
    init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
