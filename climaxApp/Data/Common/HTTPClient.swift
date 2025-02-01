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

class DefaultHTTPClient: HTTPClient {
    func get(url: URL, parameters: [String: String]? = nil) async throws -> Data {
        var requestUrl = url
        if let parameters = parameters {
            requestUrl = url.appendingQueryParameters(parameters)
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        return try await performRequest(request: request)
    }
    
    func post(url: URL, body: Data) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        
        return try await performRequest(request: request)
    }
    
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
