//
//  CityForecastViewModelTests.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import XCTest
@testable import climaxApp

final class CityForecastViewModelTests: XCTestCase {
    var viewModel: CityForecastViewModel!
    var mockGetForecastUseCase: MockGetForecastUseCase!
    var mockFavoritesUseCase: MockFavoritesUseCase!
    
    override func setUp() {
        super.setUp()
        mockGetForecastUseCase = MockGetForecastUseCase()
        mockFavoritesUseCase = MockFavoritesUseCase()
        viewModel = CityForecastViewModel(getForecastUseCase: mockGetForecastUseCase, favoritesUseCase: mockFavoritesUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockGetForecastUseCase = nil
        mockFavoritesUseCase = nil
        super.tearDown()
    }
    
    // MARK: Forecast tests

    func testGetForecast_Success() async throws {
        // Given
        let city = City.mockCity
        viewModel.selectedCity = city

        // When
        try await viewModel.getForecast()

        // Then
        XCTAssertNotNil(viewModel.forecast, "The forecast should not be null")
        XCTAssertEqual(viewModel.forecast?.currentWeather.temperature, 2.8, "The temperature should be 2.8")
        XCTAssertNil(viewModel.errorMessage, "No error should appear")
    }

    func testGetForecast_Failure() async throws {
        // Given
        mockGetForecastUseCase.shouldThrowError = true
        viewModel.selectedCity = City.mockCity

        // When
        try await viewModel.getForecast()

        // Then
        XCTAssertNotNil(viewModel.errorMessage, "There should be an error message")
        XCTAssertEqual(viewModel.errorMessage, "No location found.", "Should show the correct error message.")
    }
    
    // MARK: Favorites tests

    func testAddToFavorites() {
        // Given
        let city = City.mockCity

        // When
        viewModel.addToFavorites(city)

        // Then
        XCTAssertTrue(viewModel.favoriteCities.contains { $0.id == city.id }, "The city should be in favorites.")
    }
    
    func testRemoveFromFavorites() {
        // Given
        let city = City.mockCity
        viewModel.addToFavorites(city)

        // When
        viewModel.removeFromFavorites(city)

        // Then
        XCTAssertFalse(viewModel.favoriteCities.contains { $0.id == city.id }, "The city shouldn't be in favorites.")
    }
    
    // MARK: Other tests
    
    func testCurrentTemperature_WhenForecastIsAvailable_ShouldReturnCorrectValue() {
        // Given
        mockGetForecastUseCase.mockForecast.currentWeather.temperature = 25
        viewModel.forecast = mockGetForecastUseCase.mockForecast
        
        // When
        let result = viewModel.currentTemperature
        
        // Then
        XCTAssertEqual(result, "25", "The temperature should be 25")
    }

    func testCurrentTemperature_WhenNoForecast_ShouldReturnDash() {
        // Given
        viewModel.forecast = nil
        
        // When
        let result = viewModel.currentTemperature
        
        // Then
        XCTAssertEqual(result, "-°", "Should return -° if there are no data.")
    }

    func testFeelsLikeTemperatureText_WhenSimilarTemperature_ShouldReturnSimilarText() {
        // Given
        mockGetForecastUseCase.mockForecast.currentWeather.temperature = 20
        mockGetForecastUseCase.mockForecast.currentWeather.tempFeelsLike = 21
        viewModel.forecast = mockGetForecastUseCase.mockForecast
        
        // When
        let result = viewModel.feelsLikeTemperatureText
        
        // Then
        XCTAssertEqual(result, "Similar to the current temperature.", "Should indicate that the temperature feels similar")
    }

    func testFeelsLikeTemperatureText_WhenHotter_ShouldReturnHotterText() {
        // Given
        mockGetForecastUseCase.mockForecast.currentWeather.temperature = 20
        mockGetForecastUseCase.mockForecast.currentWeather.tempFeelsLike = 23
        viewModel.forecast = mockGetForecastUseCase.mockForecast
        
        // When
        let result = viewModel.feelsLikeTemperatureText
        
        // Then
        XCTAssertEqual(result, "Temperature feels hotter.", "Should indicate that the temperature feels hotter")
    }

    func testFeelsLikeTemperatureText_WhenCooler_ShouldReturnCoolerText() {
        // Given
        mockGetForecastUseCase.mockForecast.currentWeather.temperature = 20
        mockGetForecastUseCase.mockForecast.currentWeather.tempFeelsLike = 16
        viewModel.forecast = mockGetForecastUseCase.mockForecast
        
        // When
        let result = viewModel.feelsLikeTemperatureText
        
        // Then
        XCTAssertEqual(result, "Temperature feels cooler.", "Should indicate that the temperature feels colder")
    }

    func testUVIndexText_ShouldReturnCorrectLabel() {
        let testCases: [(uvIndex: Double, expected: String)] = [
            (1, "Low"),
            (4, "Moderate"),
            (6, "High"),
            (9, "Very High"),
            (11, "Extreme")
        ]
        
        for testCase in testCases {
            // Given
            mockGetForecastUseCase.mockForecast.currentWeather.uvIndex = testCase.uvIndex
            viewModel.forecast = mockGetForecastUseCase.mockForecast
            
            // When
            let result = viewModel.uvIndexText
            
            // Then
            XCTAssertEqual(result, testCase.expected, "UV Index \(testCase.uvIndex) should return \(testCase.expected)")
        }
    }

    func testGetWeekdayLabel_ShouldReturnTodayForCurrentDate() {
        // Given
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        // When
        let result = viewModel.getWeekdayLabel(from: todayString)
        
        // Then
        XCTAssertEqual(result, "Today", "Today's date should return 'Today'")
    }

    func testGetWeekdayLabel_ShouldReturnCorrectDay() {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let testDate = "2025-02-01"
        let expectedDay = "Sat"
        
        // When
        let result = viewModel.getWeekdayLabel(from: testDate)
        
        // Then
        XCTAssertEqual(result, expectedDay, "Should return \(expectedDay) for the date \(testDate)")
    }

}
