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
/// This protocol specifies the scheme and host components of a URL,
/// which are essential for constructing URLs for network requests.
protocol URLConfigurable {
    var scheme: String { get }
    var host: String { get }
}
/// This struct implements `URLConfigurable` to provide the scheme and host
/// for constructing the base URL of API requests.
struct ServiceConfig: URLConfigurable {
    let scheme = Constants.API.scheme
    let host = Constants.API.baseURL
}
/// This enum provides a convenient way to manage different versions of the API
/// by specifying the version in the path component of the URL.
enum APIVersion: String {
    case v1 = "/1"
    /// Returns the version as a path component string.
    var pathComponent: String {
        return self.rawValue
    }
}
/// Responsible for building URLs for network requests.
///
/// This class uses a configuration conforming to `URLConfigurable` to construct
/// URLs, including path and query items, ensuring they are correctly formatted.
class URLBuilder {
    private let config: URLConfigurable
    
    init(config: URLConfigurable) {
        self.config = config
    }
    /// Builds a URL using the provided path and query items.
    ///
    /// - Parameters:
    ///   - path: The path component of the URL.
    ///   - queryItems: The query items to be included in the URL. Optional.
    /// - Returns: The constructed URL.
    /// - Throws: An error if the URL could not be constructed.
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
/// A builder class for constructing endpoint configurations.
///
/// This class facilitates the creation of endpoint configurations by allowing
/// the configuration of path, method, query items, body, and API version.
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
    /// Builds and returns the endpoint configuration.
    ///
    /// - Returns: The endpoint configuration including path, method, query items, body, and version.
    func build() -> (path: String, method: RequestMethod, queryItems: [URLQueryItem]?, body: [String: Any]?, version: APIVersion) {
        return (path: "\(version.pathComponent)\(path)", method: method, queryItems: queryItems, body: body, version: version)
    }
}
/// Extension to print cURL commands for debugging purposes.
extension EndpointProvider {
    func printCURL(_ request: URLRequest) {
        print(request.toCURL())
    }
}
