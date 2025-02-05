//
//  GetForecastByCityUseCaseTests.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 4/02/25.
//

import XCTest
@testable import climaxApp

final class GetForecastByCityUseCaseTests: XCTestCase {
    var useCase: GetForecastByCityUseCaseImpl!
    var mockRepository: MockWeatherRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        useCase = GetForecastByCityUseCaseImpl(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_WhenCityIsValid_ShouldReturnForecast() async throws {
        // Given
        let expectedCity = "Chicago"

        // When
        let forecast = try await useCase.execute(expectedCity)

        // Then
        XCTAssertEqual(forecast.currentWeather.temperature, 2.8, "The expected temperature is 2.8°C")
        XCTAssertEqual(forecast.currentWeather.tempFeelsLike, -2.1, "The expected temperature feels like is -2.1°C")
        XCTAssertEqual(forecast.currentWeather.uvIndex, 0.0, "The expected UV index is 0.0")
    }
}
