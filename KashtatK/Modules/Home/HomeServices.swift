//
//  HomeServices.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import Foundation

final class HomeServices {
    static func getPopularProducts(for id: String) async throws -> Products {
        let endpoint = Endpoints.getProductsByPopular(id: id)
        return try await APITask.shared.asyncRequest(endpoint: endpoint, responseModel: Products.self)
    }
    
    static func getProducts() async throws -> Products {
        let endpoint = Endpoints.getProducts
        return try await APITask.shared.asyncRequest(endpoint: endpoint, responseModel: Products.self)
    }
    
    static func getProducts(with id: String) async throws -> Products {
        let endpoint = Endpoints.getProductsBy(id: id)
        return try await APITask.shared.asyncRequest(endpoint: endpoint, responseModel: Products.self)
    }
    
    static func getProducts(by id: String) async throws -> ProductObjectModel {
        let endpoint = Endpoints.getProductsBy(id: id)
        return try await APITask.shared.asyncRequest(endpoint: endpoint, responseModel: ProductObjectModel.self)
    }
}
