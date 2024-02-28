//
//  Types.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation

extension Encodable {
    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Notification.Name {
    static let terminateSession = Notification.Name("terminateSession")
}

extension URLRequest {
    func toCURL() -> String {
        var components = ["$ curl -i"]

        if let method = httpMethod {
            components.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                components.append("-H \"\(key): \(value)\"")
            }
        }

        if let body = httpBody, let bodyString = String(data: body, encoding: .utf8), !bodyString.isEmpty {
            components.append("-d '\(bodyString)'")
        }

        if let url = url {
            components.append("\"\(url.absoluteString)\"")
        }

        return components.joined(separator: " ")
    }
}

struct ContentStates {
    var isError: Bool = false
    var isSuccess: Bool = false
    var isLoading: Bool = false
    var errorModel: ErrorModal?
}

struct ErrorModal: Equatable {
    var id = UUID()
    var errorMessage: String?
    var action: (() -> Void)?
    
    init(errorMessage: String? = nil, action: (() -> Void)? = nil) {
        self.errorMessage = errorMessage
        self.action = action
    }
    
    static func == (lhs: ErrorModal, rhs: ErrorModal) -> Bool {
        return lhs.id == rhs.id
    }
}
