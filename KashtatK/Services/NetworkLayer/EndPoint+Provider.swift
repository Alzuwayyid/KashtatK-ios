//
//  EndPoint.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation
/// A protocol defining the requirements for an API endpoint.
///
/// This protocol provides the necessary details to construct a request to an API endpoint,
/// including the path, HTTP method, query items, request body, and version of the API.
protocol EndpointProvider {
    var path: String { get }
    var method: RequestMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var version: APIVersion { get }
}

extension EndpointProvider {
    /// Converts the endpoint into a `URLRequest` ready for network transmission.
    ///
    /// This method constructs a URL using the endpoint's properties (path, query items)
    /// and the service configuration. It then configures a `URLRequest` with this URL,
    /// sets the HTTP method, adds necessary headers, and serializes the request body
    /// into JSON if it exists.
    ///
    /// - Throws: `APIError` if URL construction fails or if there's an error encoding the HTTP body.
    /// - Returns: A fully configured `URLRequest`.
    func asURLRequest() throws -> URLRequest {
        let config = ServiceConfig()
        let urlBuilder = URLBuilder(config: config)
        let url: URL
        do {
            // Attempt to construct the full URL from the endpoint's properties.
            url = try urlBuilder.buildURL(withPath: path, queryItems: queryItems)
        } catch {
            // If URL construction fails, throw an error with a specific message.
            throw APIError(errorCode: "ERROR-0", message: "URL Construction Error")
        }
        
        // Initialize the URLRequest with the constructed URL.
        var urlRequest = URLRequest(url: url)
        
        // Set the HTTP method for the request.
        urlRequest.httpMethod = method.rawValue
        
        // Add necessary headers required by the API.
        urlRequest.addValue(Constants.API.apiKey, forHTTPHeaderField: "X-Algolia-API-Key")
        urlRequest.addValue(Constants.API.appId, forHTTPHeaderField: "X-Algolia-Application-Id")
        
        // Log the cURL command equivalent of the URLRequest for debugging purposes.
        printCURL(urlRequest)
        
        // Serialize the request body into JSON if it exists.
        if let body = body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                // If body serialization fails, throw an error with a specific message.
                throw APIError(errorCode: "ERROR-1", message: "Error encoding http body")
            }
        }
        
        // Return the fully configured URLRequest.
        return urlRequest
    }
}
