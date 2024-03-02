//
//  Products.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation
import SwiftData
// MARK: - Products
@Model
class Products: Codable {
    @Relationship(deleteRule: .cascade) var hits = [Hit]()
    let nbHits: Int?
    let page: Int?
    let nbPages: Int?
    let hitsPerPage: Int?
    let exhaustiveNbHits: Bool?
    let exhaustiveTypo: Bool?
    let exhaustive: ProductExhaustive?
    let query: String?
    let params: String?
    let renderingContent: RenderingContent?
    let processingTimeMS: Int?
    let processingTimingsMS: ProcessingTimingsMS?
    let serverTimeMS: Int?

    enum CodingKeys: String, CodingKey {
        case hits, nbHits, page, nbPages, hitsPerPage, exhaustiveNbHits, exhaustiveTypo, exhaustive, query, params, renderingContent, processingTimeMS, processingTimingsMS, serverTimeMS
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hits = try container.decode([Hit].self, forKey: .hits)
        nbHits = try container.decodeIfPresent(Int.self, forKey: .nbHits)
        page = try container.decodeIfPresent(Int.self, forKey: .page)
        nbPages = try container.decodeIfPresent(Int.self, forKey: .nbPages)
        hitsPerPage = try container.decodeIfPresent(Int.self, forKey: .hitsPerPage)
        exhaustiveNbHits = try container.decodeIfPresent(Bool.self, forKey: .exhaustiveNbHits)
        exhaustiveTypo = try container.decodeIfPresent(Bool.self, forKey: .exhaustiveTypo)
        exhaustive = try container.decodeIfPresent(ProductExhaustive.self, forKey: .exhaustive)
        query = try container.decodeIfPresent(String.self, forKey: .query)
        params = try container.decodeIfPresent(String.self, forKey: .params)
        renderingContent = try container.decodeIfPresent(RenderingContent.self, forKey: .renderingContent)
        processingTimeMS = try container.decodeIfPresent(Int.self, forKey: .processingTimeMS)
        processingTimingsMS = try container.decodeIfPresent(ProcessingTimingsMS.self, forKey: .processingTimingsMS)
        serverTimeMS = try container.decodeIfPresent(Int.self, forKey: .serverTimeMS)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hits, forKey: .hits)
        try container.encodeIfPresent(nbHits, forKey: .nbHits)
        try container.encodeIfPresent(page, forKey: .page)
        try container.encodeIfPresent(nbPages, forKey: .nbPages)
        try container.encodeIfPresent(hitsPerPage, forKey: .hitsPerPage)
        try container.encodeIfPresent(exhaustiveNbHits, forKey: .exhaustiveNbHits)
        try container.encodeIfPresent(exhaustiveTypo, forKey: .exhaustiveTypo)
        try container.encodeIfPresent(exhaustive, forKey: .exhaustive)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(params, forKey: .params)
        try container.encodeIfPresent(renderingContent, forKey: .renderingContent)
        try container.encodeIfPresent(processingTimeMS, forKey: .processingTimeMS)
        try container.encodeIfPresent(processingTimingsMS, forKey: .processingTimingsMS)
        try container.encodeIfPresent(serverTimeMS, forKey: .serverTimeMS)
    }
}

// MARK: - Exhaustive
struct ProductExhaustive: Codable {
    let nbHits, typo: Bool
}

// MARK: - Hit
@Model
class Hit: Codable {
    let productName: String?
    let category: String?
    let trend: String?
    let price: Double?
    let rating: Double?
    let stock: Int?
    let desc: String?
    let images: String?
    let objectID: String?
//    let highlightResult: HighlightResult?
//    @Relationship(deleteRule: .cascade) var highlightResult: HighlightResult?
    
    enum CodingKeys: String, CodingKey {
        case productName = "Product Name"
        case category = "Category"
        case trend = "Trend"
        case price = "Price"
        case rating = "Rating"
        case stock = "Stock"
        case desc = "Description"
        case images = "Images"
        case objectID = "objectID"
        case highlightResult = "_highlightResult"
    }

    // Custom initializer to decode
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productName = try container.decode(String.self, forKey: .productName)
        category = try container.decode(String.self, forKey: .category)
        trend = try container.decode(String.self, forKey: .trend)
        price = try container.decode(Double.self, forKey: .price)
        rating = try container.decode(Double.self, forKey: .rating)
        stock = try container.decode(Int.self, forKey: .stock)
        desc = try container.decode(String.self, forKey: .desc)
        images = try container.decode(String.self, forKey: .images)
        objectID = try container.decode(String.self, forKey: .objectID)
//        highlightResult = try container.decode(HighlightResult.self, forKey: .highlightResult)
    }

    // Encode function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productName, forKey: .productName)
        try container.encode(category, forKey: .category)
        try container.encode(trend, forKey: .trend)
        try container.encode(price, forKey: .price)
        try container.encode(rating, forKey: .rating)
        try container.encode(stock, forKey: .stock)
        try container.encode(desc, forKey: .desc)
        try container.encode(images, forKey: .images)
        try container.encode(objectID, forKey: .objectID)
//        try container.encode(highlightResult, forKey: .highlightResult)
    }
}

// MARK: - HighlightResult
@Model
class HighlightResult: Codable {
    @Relationship(deleteRule: .cascade) var productName: Category?
    @Relationship(deleteRule: .cascade) var category: Category?

    // Custom initializer to decode
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productName = try container.decode(Category.self, forKey: .productName)
        category = try container.decode(Category.self, forKey: .category)
    }

    // Encode function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productName, forKey: .productName)
        try container.encode(category, forKey: .category)
    }
    
    enum CodingKeys: String, CodingKey {
        case productName = "Product Name"
        case category = "Category"
    }
}

// MARK: - Category
@Model
class Category: Codable {
    let value: String
    let matchLevel: String
    let matchedWords: [String]
    
    // Custom initializer to decode
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        matchLevel = try container.decode(String.self, forKey: .matchLevel)
        matchedWords = try container.decode([String].self, forKey: .matchedWords)
    }

    // Encode function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(matchLevel, forKey: .matchLevel)
        try container.encode(matchedWords, forKey: .matchedWords)
    }
    
    enum CodingKeys: String, CodingKey {
        case value
        case matchLevel
        case matchedWords
    }
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

// MARK: - Products
struct ProductObjectModel: Codable {
    let hits: [HitObjectModel]
    let nbHits, page, nbPages, hitsPerPage: Int
    let exhaustiveNbHits, exhaustiveTypo: Bool
    let exhaustive: Exhaustive
    let query, params: String
    let renderingContent: RenderingContent
    let processingTimeMS: Int
    let processingTimingsMS: ProcessingTimingsMS
    let serverTimeMS: Int
}

// MARK: - Exhaustive
struct Exhaustive: Codable {
    let nbHits, typo: Bool
}

// MARK: - Hit
struct HitObjectModel: Codable {  
    var id: String { objectID }
    let productName, category, trend: String
    let price, rating: Double
    let stock: Int
    let description: String
    let images: String
    let popular, objectID: String
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
        case popular, objectID
        case highlightResult = "_highlightResult"
    }
}
