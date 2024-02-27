//
//  EndPoint.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation

protocol EndpointProvider {
    var path: String { get }
    var method: RequestMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var version: APIVersion { get }
}

extension EndpointProvider {
    func asURLRequest() throws -> URLRequest { 
        let config = ServiceConfig()
        let urlBuilder = URLBuilder(config: config)
        let url: URL
        do {
            url = try urlBuilder.buildURL(withPath: path, queryItems: queryItems)
        } catch {
            // Handle or rethrow the error if URL construction fails
            throw APIError(errorCode: "ERROR-0", message: "URL Construction Error")
        }
        
        // Now that we have a valid URL, we can proceed with configuring the URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        // Add necessary headers
        urlRequest.addValue(Constants.API.apiKey, forHTTPHeaderField: "X-Algolia-API-Key")
        urlRequest.addValue(Constants.API.appId, forHTTPHeaderField: "X-Algolia-Application-Id")
        printCURL(urlRequest)
        // If there's a body to be included in the request, serialize it into JSON
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                // Handle or rethrow the error if body serialization fails
                throw APIError(errorCode: "ERROR-1", message: "Error encoding http body")
            }
        }
        
        // The URLRequest is now fully configured and can be returned
        return urlRequest
    }
}
