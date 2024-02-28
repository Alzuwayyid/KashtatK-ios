//
//  HomeServices.swift
//  KashtatK
//
//  Created by Mohammed on 28/02/2024.
//

import Foundation

final class HomeServices {
    static func getProducts(for id: String) async throws -> Products {
        let endpoint = Endpoints.getProductsByPopular(id: id)
        return try await APITask.shared.asyncRequest(endpoint: endpoint, responseModel: Products.self)
    }
}
