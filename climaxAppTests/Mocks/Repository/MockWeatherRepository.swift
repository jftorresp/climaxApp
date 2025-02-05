//
//  MockWeatherRepository.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 4/02/25.
//

import Foundation
@testable import climaxApp

class MockWeatherRepository: WeatherRepository {
    var shouldThrowError = false
    var mockCities: [CityModel] = [CityModel.mockNewYorkCity, CityModel.mockChicagoCity]
    
    func getForecastByCity(_ city: String) async throws -> ForecastModel {
        if shouldThrowError {
            throw DomainError.noLocationFound
        }
        return ForecastModel.mockForecast
    }
    
    func searchCity(_ query: String) async throws -> [CityModel] {
        if shouldThrowError {
            return []
        }
        return mockCities.filter { $0.name.lowercased().contains(query.lowercased()) }
    }
}
