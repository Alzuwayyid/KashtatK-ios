//
//  EndPoint+Config.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

protocol URLConfigurable {
    var scheme: String { get }
    var host: String { get }
}

struct ServiceConfig: URLConfigurable {
    let scheme = Constants.API.scheme
    let host = Constants.API.baseURL
}

enum APIVersion: String {
    case v1 = "/1"
    var pathComponent: String {
        return self.rawValue
    }
}

class URLBuilder {
    private let config: URLConfigurable
    
    init(config: URLConfigurable) {
        self.config = config
    }
    
    func buildURL(withPath path: String, queryItems: [URLQueryItem]?) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = config.scheme
        urlComponents.host = config.host
        urlComponents.path = path
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw APIError(errorCode: "ERROR-0", message: "URL Construction Error")
        }
        
        return url
    }
}

class EndpointBuilder {
    private var path: String = ""
    private var method: RequestMethod = .get
    private var queryItems: [URLQueryItem]? = nil
    private var body: [String: Any]? = nil
    private var version: APIVersion = .v1

    @discardableResult
    func setPath(_ path: String) -> EndpointBuilder {
        self.path = path
        return self
    }

    @discardableResult
    func setMethod(_ method: RequestMethod) -> EndpointBuilder {
        self.method = method
        return self
    }

    @discardableResult
    func setQueryItems(_ queryItems: [URLQueryItem]?) -> EndpointBuilder {
        self.queryItems = queryItems
        return self
    }

    @discardableResult
    func setBody(_ body: [String: Any]?) -> EndpointBuilder {
        self.body = body
        return self
    }

    @discardableResult
    func setVersion(_ version: APIVersion) -> EndpointBuilder {
        self.version = version
        return self
    }

    func build() -> (path: String, method: RequestMethod, queryItems: [URLQueryItem]?, body: [String: Any]?, version: APIVersion) {
        return (path: "\(version.pathComponent)\(path)", method: method, queryItems: queryItems, body: body, version: version)
    }
}


extension EndpointProvider {
    func printCURL(_ request: URLRequest) {
        print(request.toCURL())
    }
}
