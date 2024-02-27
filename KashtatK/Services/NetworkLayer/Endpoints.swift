//
//  Endpoint+Events.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation

enum Endpoints: EndpointProvider {
    case getProducts
    case attendEvent(id: String)

    var configuration: EndpointConfiguration {
        switch self {
        case .getProducts:
            return EndpointBuilder()
                .setVersion(.v1)
                .setMethod(.get)
                .setPath("/indexes/\(Constants.API.productName)")
                .build()

        case .attendEvent(let id):
            return EndpointBuilder()
                .setVersion(.v1) 
                .setMethod(.put)
                .setPath("/api/v2/activity/event/attending")
                .setQueryItems([URLQueryItem(name: "eventId", value: id)])
                .build()
        }
    }

    var path: String { configuration.path }
    var method: RequestMethod { configuration.method }
    var queryItems: [URLQueryItem]? { configuration.queryItems }
    var body: [String: Any]? { configuration.body }
    var version: APIVersion { configuration.version }
}

// Define EndpointConfiguration to match the builder's return type for clarity.
typealias EndpointConfiguration = (path: String, method: RequestMethod, queryItems: [URLQueryItem]?, body: [String: Any]?, version: APIVersion)

