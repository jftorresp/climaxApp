//
//  MockForecastUseCase.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import Foundation
@testable import climaxApp

class MockGetForecastUseCase: GetForecastByCityUseCase {
    var shouldThrowError = false
    var mockForecast = Forecast.mockForecast

    func execute(_ cityName: String) async throws -> Forecast {
        if shouldThrowError {
            throw DomainError.noLocationFound
        }
        return mockForecast
    }
}
