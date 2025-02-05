//
//  NetworkService.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

protocol HTTPClient {
    func get(url: URL, parameters: [String: String]?) async throws -> Data
    func post(url: URL, body: Data) async throws -> Data
    func performRequest(request: URLRequest) async throws -> Data
}

/// A default implementation of the `HTTPClient` protocol that handles network requests.
///
/// `DefaultHTTPClient` provides methods for performing HTTP GET and POST requests asynchronously,
/// handling responses, and decoding error messages.
///
/// ## Features:
/// - Supports GET and POST requests.
/// - Handles query parameters in URLs.
/// - Processes HTTP responses and throws appropriate errors.
/// - Decodes error messages from server responses.
///
/// - Conforms to: `HTTPClient`
class DefaultHTTPClient: HTTPClient {
    /// Sends an asynchronous HTTP GET request and returns the response data.
    ///
    /// This function constructs a `URLRequest` with the specified `URL` and optional query parameters,
    /// then performs the request asynchronously.
    ///
    /// - Parameters:
    ///   - url: The base `URL` for the GET request.
    ///   - parameters: An optional dictionary of query parameters to be appended to the URL.
    /// - Returns: The `Data` received from the server.
    /// - Throws: An error if the request fails.
    func get(url: URL, parameters: [String: String]? = nil) async throws -> Data {
        var requestUrl = url
        if let parameters = parameters {
            requestUrl = url.appendingQueryParameters(parameters)
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        return try await performRequest(request: request)
    }
    
    /// Sends an asynchronous HTTP POST request with a request body and returns the response data.
    ///
    /// This function constructs a `URLRequest` with the specified `URL`, sets the HTTP method to `POST`,
    /// attaches the provided request body, and performs the request asynchronously.
    ///
    /// - Parameters:
    ///   - url: The `URL` where the POST request will be sent.
    ///   - body: The `Data` payload to be sent in the request body.
    /// - Returns: The `Data` received from the server as a response.
    /// - Throws: An error if the request fails.
    func post(url: URL, body: Data) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        
        return try await performRequest(request: request)
    }
    
    /// Executes an asynchronous network request and handles HTTP response codes.
    ///
    /// This function sends a `URLRequest` using `URLSession`, validates the response, and returns the received data.
    /// If the response contains an error status code, it decodes the error message and throws a corresponding `HTTPError`.
    ///
    /// - Parameter request: A `URLRequest` containing the URL, HTTP method, headers, and body (if applicable).
    /// - Returns: The `Data` received from the server if the request is successful.
    /// - Throws:
    ///   - `NetworkError.invalidResponse` if the response is not a valid HTTP response.
    ///   - `HTTPError.badRequest` (400) if the request is malformed.
    ///   - `HTTPError.unauthorized` (401) if authentication fails.
    ///   - `HTTPError.forbidden` (403) if access is denied.
    ///   - `HTTPError.notFound` (404) if the requested resource is not found.
    ///   - `HTTPError.serverError` (500) if the server encounters an issue.
    ///   - `HTTPError.unknown` for any other unexpected status codes.
    func performRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
                
        switch httpResponse.statusCode {
        case 200..<300:
            return data
        case 400:
            let errorMessage = try await decodeErrorMessage(data: data)
            throw HTTPError.badRequest(message: errorMessage)
        case 401:
            let errorMessage = try await decodeErrorMessage(data: data)
            throw HTTPError.unauthorized(message: errorMessage)
        case 403:
            let errorMessage = try await decodeErrorMessage(data: data)
            throw HTTPError.forbidden(message: errorMessage)
        case 404:
            let errorMessage = try await decodeErrorMessage(data: data)
            throw HTTPError.notFound(message: errorMessage)
        case 500:
            let errorMessage = try await decodeErrorMessage(data: data)
            throw HTTPError.serverError(message: errorMessage)
        default:
            let errorMessage = try await decodeErrorMessage(data: data)
            throw HTTPError.unknown(code: httpResponse.statusCode, message: errorMessage)
        }
    }
    
    /// Decodes an error message from a given JSON response.
    ///
    /// This function attempts to decode a `Data` object into an `ErrorData` model to extract the error message.
    /// If decoding fails, it throws a `NetworkError.decodingError` with the corresponding error description.
    ///
    /// - Parameter data: The `Data` object containing the error response from the server.
    /// - Returns: A `String?` representing the decoded error message, or `nil` if no message is available.
    /// - Throws: `NetworkError.decodingError` if the decoding process fails.
    private func decodeErrorMessage(data: Data) async throws -> String? {
        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(ErrorData.self, from: data)
            return decodedResponse.error?.message
        } catch (let error) {
            throw NetworkError.decodingError(message: error.localizedDescription)
        }
    }
}

internal extension URL {
    /// Appends query parameters to a URL.
    ///
    /// This function takes a dictionary of query parameters and appends them to the URL as key-value pairs.
    /// If the URL already contains query parameters, the new parameters are added to the existing ones.
    ///
    /// - Parameter parameters: A dictionary where the keys represent query parameter names and the values represent their corresponding values.
    /// - Returns: A new `URL` with the provided query parameters appended.
    /// - Note: This function forcefully unwraps (`!`) the resulting `URL`. Ensure that the base URL is valid before using this function.
    func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = components.queryItems ?? []
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        return components.url!
    }
}
