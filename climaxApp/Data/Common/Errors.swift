//
//  NetworkError.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case badURL
    case requestFailed
    case invalidResponse
    case decodingError(message: String)
    case unkwownError(code: Int, message: String)
}

enum HTTPError: Error {
    case invalidResponse(message: String?)
    case badRequest(message: String?)
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case notFound(message: String?)
    case serverError(message: String?)
    case unknown(code: Int, message: String?)
}

enum DataError: Error {
    case apiError(code: Int, message: String)
    case unkwownError(message: String)
}

struct ErrorData: Decodable {
    let error: ErrorDataContent?
}

struct ErrorDataContent: Decodable {
    let code: Int?
    let message: String?
}
