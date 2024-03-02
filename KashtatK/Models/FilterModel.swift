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
    var trends: [Trend]
    var filterKeyWords: [SearchKeywords]
    
    init(popularSearches: [SearchKeywords], trends: [Trend], filterKeyWords: [SearchKeywords]) {
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

@Model
class Trend {
    var id: String
    var title: String
    var imageUrl: String
    
    init(id: String, title: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
    }
}
