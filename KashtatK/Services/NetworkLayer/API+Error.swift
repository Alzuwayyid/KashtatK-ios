//
//  APIError.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import Foundation

struct APIError: Error {
    var statusCode: Int!
    let errorCode: String
    var message: String

    init(statusCode: Int = 0, errorCode: String, message: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }

    var errorCodeNumber: String {
        let numberString = errorCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return numberString
    }

    private enum CodingKeys: String, CodingKey {
        case errorCode
        case message
    }
}

extension APIError: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(String.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
    }
}

enum ErrorValues: String, Error {
    case decodingDataError = "The data couldn't be decoded."
    case networkUnavailable = "The network is unavailable."
    case unauthorizedAccess = "Unauthorized access."
    case resourceNotFound = "The requested resource was not found."
    case expiredToken = "Expired token"
}
