//
//  RemoteDataSource.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

protocol WeatherRemoteDataSource {
    func getForecastByCity(_ city: String) async throws -> ForecastResponse
    func searchCity(_ query: String) async throws -> [CityResponse]
}

class WeatherRemoteDataSourceImpl: WeatherRemoteDataSource {
    let httpClient: HTTPClient
    let apiKey: String
    
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
