//
//  RemoteDataSource.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

/// Defines the contract for fetching weather data from a remote API.
protocol WeatherRemoteDataSource {
    
    /// Fetches the weather forecast for a given city.
    ///
    /// - Parameter city: The name of the city for which to retrieve the weather forecast.
    /// - Returns: A `ForecastResponse` containing weather forecast data.
    /// - Throws: An error if the network request fails or if decoding the response data fails.
    func getForecastByCity(_ city: String) async throws -> ForecastResponse

    /// Searches for cities matching a given query.
    ///
    /// - Parameter query: The search string used to find matching cities.
    /// - Returns: An array of `CityResponse` objects representing the matching cities.
    /// - Throws: An error if the network request fails or if decoding the response data fails.
    func searchCity(_ query: String) async throws -> [CityResponse]
}

/// An implementation of `WeatherRemoteDataSource` that fetches weather data from a remote API.
///
/// `WeatherRemoteDataSourceImpl` uses an `HTTPClient` to send network requests and retrieve weather data.
/// The API key is loaded from a `config.json` file located in the app bundle.
///
/// - Requires: A valid `config.json` file containing an `"api_key"` entry.
///
/// ## Features:
/// - Fetches weather forecast data for a specific city.
/// - Searches for cities based on a query.
/// - Handles network errors and API response decoding failures.
class WeatherRemoteDataSourceImpl: WeatherRemoteDataSource {
    let httpClient: HTTPClient
    let apiKey: String

    /// Initializes a new instance of `WeatherRemoteDataSourceImpl`.
    ///
    /// - Parameter httpClient: The HTTP client used to perform network requests. Defaults to `DefaultHTTPClient()`.
    init(httpClient: HTTPClient = DefaultHTTPClient()) {
        guard let path = Bundle.main.path(forResource: "config", ofType: "json") else {
            fatalError("Failed to load config.json")
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
            fatalError("Invalid config.json format")
        }

        self.httpClient = httpClient
        self.apiKey = json["api_key"] ?? ""
    }

    /// Fetches the weather forecast for a given city.
    ///
    /// - Parameter city: The name of the city for which to retrieve the weather forecast.
    /// - Returns: A `ForecastResponse` containing weather forecast data.
    /// - Throws:
    ///   - `DataError.apiError` if the API returns an error response.
    ///   - `NetworkError.decodingError` if the response cannot be decoded correctly.
    func getForecastByCity(_ city: String) async throws -> ForecastResponse {
        let url = DataConstants.baseURL.appendingPathComponent("forecast.json")

        do {
            let data = try await httpClient.get(
                url: url,
                parameters: [
                    "key": apiKey,
                    "q": city,
                    "days": "4"
                ]
            )

            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw DataError.apiError(code: apiError.error.code, message: apiError.error.message)
            }

            return try JSONDecoder().decode(ForecastResponse.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            throw NetworkError.decodingError(message: context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            throw NetworkError.decodingError(message: "Key \(key.stringValue) not found: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            throw NetworkError.decodingError(message: "Expected to decode \(type), but found \(context.debugDescription)")
        } catch {
            throw NetworkError.decodingError(message: error.localizedDescription)
        }
    }

    /// Searches for cities matching a given query.
    ///
    /// - Parameter query: The search string used to find matching cities.
    /// - Returns: An array of `CityResponse` objects representing the matching cities.
    /// - Throws:
    ///   - `DataError.apiError` if the API returns an error response.
    ///   - `NetworkError.decodingError` if the response cannot be decoded correctly.
    func searchCity(_ query: String) async throws -> [CityResponse] {
        let url = DataConstants.baseURL.appendingPathComponent("search.json")

        do {
            let data = try await httpClient.get(
                url: url,
                parameters: [
                    "key": apiKey,
                    "q": query,
                ]
            )

            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw DataError.apiError(code: apiError.error.code, message: apiError.error.message)
            }

            return try JSONDecoder().decode([CityResponse].self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            throw NetworkError.decodingError(message: context.debugDescription)
        } catch let DecodingError.keyNotFound(key, context) {
            throw NetworkError.decodingError(message: "Key \(key.stringValue) not found: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            throw NetworkError.decodingError(message: "Expected to decode \(type), but found \(context.debugDescription)")
        } catch {
            throw NetworkError.decodingError(message: error.localizedDescription)
        }
    }
}
