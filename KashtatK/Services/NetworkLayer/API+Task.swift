//
//  API+Client.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import SwiftUI

protocol APIProtocol {
    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
}

final class APITask: APIProtocol {
    static let shared = APITask()

    private init() {}
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60 // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForResource = 300 // seconds for whole resource request to complete ,.
        return URLSession(configuration: configuration)
    }
    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest())
            return try self.manageResponse(data: data, response: response)
        } catch let error as APIError { // 3
            throw error
        } catch {
            throw APIError(
                errorCode: "ERROR-0",
                message: "Unknown API error \(error.localizedDescription)"
            )
        }
    }
}

extension APITask {
    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError(
                errorCode: "ERROR-0",
                message: "Invalid HTTP response"
            )
        }
        switch httpResponse.statusCode {
        case 200...299:
            do {
                // Decode the data to the expected model
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                
                // Optionally, convert the original data back to JSON for logging
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("✅ Success with status code: \(httpResponse.statusCode), Response: \(jsonString)")
                } else {
                    print("✅ Success with status code: \(httpResponse.statusCode), but could not print JSON response")
                }
                
                return decodedResponse
            } catch {
                print("‼️ Decoding error: \(error)")
                throw APIError(
                    errorCode: ErrorValues.decodingDataError.rawValue,
                    message: "Error decoding data"
                )
            }
        default:
            guard let decodedError = try? JSONDecoder().decode(APIError.self, from: data) else {
                throw APIError(
                    statusCode: httpResponse.statusCode,
                    errorCode: "ERROR-0",
                    message: "Unknown backend error"
                )
            }
            if httpResponse.statusCode == 403 && decodedError.errorCode == ErrorValues.expiredToken.rawValue {
                NotificationCenter.default.post(name: .terminateSession, object: self)
            }
            throw APIError(
                statusCode: httpResponse.statusCode,
                errorCode: decodedError.errorCode,
                message: decodedError.message
            )
        }
    }
}

