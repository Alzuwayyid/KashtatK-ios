//
//  Products.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation

// MARK: - Products
struct Products: Codable {
    let hits: [Hit]
    let nbHits, page, nbPages, hitsPerPage: Int?
    let exhaustiveNbHits, exhaustiveTypo: Bool?
    let exhaustive: ProductExhaustive?
    let query, params: String?
    let renderingContent: RenderingContent?
    let processingTimeMS: Int?
    let processingTimingsMS: ProcessingTimingsMS?
    let serverTimeMS: Int?
}

// MARK: - Exhaustive
struct ProductExhaustive: Codable {
    let nbHits, typo: Bool
}

// MARK: - Hit
struct Hit: Codable {
    let productName, category, trend: String
    let price, rating: Double
    let stock: Int
    let description: String
    let images: [[String]]
    let objectID: String
    let highlightResult: HighlightResult

    enum CodingKeys: String, CodingKey {
        case productName = "Product Name"
        case category = "Category"
        case trend = "Trend"
        case price = "Price"
        case rating = "Rating"
        case stock = "Stock"
        case description = "Description"
        case images = "Images"
        case objectID
        case highlightResult = "_highlightResult"
    }
}

// MARK: - HighlightResult
struct HighlightResult: Codable {
    let productName, category, description: Category

    enum CodingKeys: String, CodingKey {
        case productName = "Product Name"
        case category = "Category"
        case description = "Description"
    }
}

// MARK: - Category
struct Category: Codable {
    let value: String
    let matchLevel: String
    let matchedWords: [String]
}

// MARK: - RenderingContent
struct RenderingContent: Codable {
}

// MARK: - ProcessingTimingsMS
struct ProcessingTimingsMS: Codable {
    let request: ProductRequest

    enum CodingKeys: String, CodingKey {
        case request = "_request"
    }
}

// MARK: - Request
struct ProductRequest: Codable {
    let roundTrip: Int
}
