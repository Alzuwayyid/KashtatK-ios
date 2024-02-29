//
//  SearchModel.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import SwiftData

@Model
class SearchModel {
    var searchedQueries: String
    
    init(searchedQueries: String) {
        self.searchedQueries = searchedQueries
    }
}
