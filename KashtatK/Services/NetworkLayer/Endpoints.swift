//
//  Endpoint+Events.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation
/// Enum defining specific endpoints within the API.
///
/// This enum contains cases for each endpoint of the API, providing a strongly typed
/// way to specify the endpoint and its configuration such as path, method, and other request details.
enum Endpoints: EndpointProvider {
    case getProducts
    case getProductsByCategory(id: String)
    case getProductsByPopular(id: String)
    case getProductsByTrend(id: String)
    /// Configuration for the endpoint, constructed using the `EndpointBuilder`.
    ///
    /// Based on the endpoint case, it sets up the version, HTTP method, path,
    /// and any necessary query items or body parameters required for the request.
    var configuration: EndpointConfiguration {
        switch self {
            case .getProducts:
                return EndpointBuilder()
                    .setVersion(.v1)
                    .setMethod(.get)
                    .setPath("/indexes/finalData")
                    .build()
            case .getProductsByCategory(let id):
                return EndpointBuilder()
                    .setVersion(.v1)
                    .setMethod(.get)
                    .setPath("/indexes/category/")
                    .setQueryItems([URLQueryItem(name: "query", value: id)])
                    .build()
            case .getProductsByPopular(let id):
                return EndpointBuilder()
                    .setVersion(.v1)
                    .setMethod(.get)
                    .setPath("/indexes/popular/")
                    .setQueryItems([URLQueryItem(name: "query", value: id)])
                    .build()
            case .getProductsByTrend(let id):
                return EndpointBuilder()
                    .setVersion(.v1)
                    .setMethod(.get)
                    .setPath("/indexes/trends2/")
                    .setQueryItems([URLQueryItem(name: "query", value: id)])
                    .build()
        }
    }

    var path: String { configuration.path }
    var method: RequestMethod { configuration.method }
    var queryItems: [URLQueryItem]? { configuration.queryItems }
    var body: [String: Any]? { configuration.body }
    var version: APIVersion { configuration.version }
}

/// Defines the configuration for an API endpoint, including the path, method, query items, body, and API version.
typealias EndpointConfiguration = (path: String, method: RequestMethod, queryItems: [URLQueryItem]?, body: [String: Any]?, version: APIVersion)

