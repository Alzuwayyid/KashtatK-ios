//
//  API+Client.swift
//  KashtatK
//
//  Created by Mohammed on 27/02/2024.
//

import SwiftUI
/// Defines the requirements for making asynchronous API requests.
///
/// This protocol abstracts the asynchronous request-making process, allowing for generic decoding of the response.
protocol APIProtocol {
    /// Performs an asynchronous request to a specified endpoint and decodes the response.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to which the request is made, conforming to `EndpointProvider`.
    ///   - responseModel: The expected model type that the response should be decoded into.
    /// - Returns: A decoded model of type `T`, where `T` conforms to `Decodable`.
    /// - Throws: An `APIError` if the request fails or if decoding the response fails.
    func asyncRequest<T: Decodable>(endpoint: EndpointProvider, responseModel: T.Type) async throws -> T
}
/// A singleton class responsible for executing asynchronous network requests.
///
/// `APITask` utilizes the `URLSession` for network communication, adhering to the `APIProtocol`.
/// It ensures network requests are made asynchronously and handles response decoding and error processing.
final class APITask: APIProtocol {
    static let shared = APITask()

    private init() {}
    /// Configured `URLSession` for network requests.
    ///
    /// This session is configured with default settings, including connectivity checks and timeout intervals.
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60 // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForResource = 300 // seconds for whole resource request to complete ,.
        return URLSession(configuration: configuration)
    }
    /// Asynchronously sends a request to the specified endpoint and decodes the response.
    ///
    /// - Parameters:
    ///   - endpoint: The `EndpointProvider` specifying the details of the request.
    ///   - responseModel: The type (`Decodable`) of the model to decode the response into.
    /// - Returns: A model of type `T` decoded from the response.
    /// - Throws: `APIError` if there's an issue with network communication or response decoding.
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
    /// Processes the HTTP response, decoding it into the specified model type.
    ///
    /// - Parameters:
    ///   - data: The data returned by the server.
    ///   - response: The HTTP URL response received from the server.
    /// - Returns: The decoded model of type `T`.
    /// - Throws: An `APIError` if the response indicates an error or if decoding fails.
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

