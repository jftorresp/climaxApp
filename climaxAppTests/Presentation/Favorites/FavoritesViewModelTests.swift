//
//  FavoritesViewModelTests.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import XCTest
@testable import climaxApp

final class FavoritesViewModelTests: XCTestCase {
    var viewModel: FavoritesViewModel!
    var mockFavoritesUseCase: MockFavoritesUseCase!

    override func setUp() {
        super.setUp()
        mockFavoritesUseCase = MockFavoritesUseCase()
        viewModel = FavoritesViewModel(favoritesUseCase: mockFavoritesUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockFavoritesUseCase = nil
        super.tearDown()
    }

    func testLoadFavoriteCities_ShouldLoadStoredCities() {
        // Given
        let city1 = City.mockNewYorkCity
        let city2 = City.mockChicagoCity
        mockFavoritesUseCase.savedCities = [city1, city2]

        // When
        viewModel.loadFavoriteCities()

        // Then
        XCTAssertEqual(viewModel.favoriteCities.count, 2, "There should be 2 cities in favorites")
        XCTAssertEqual(viewModel.favoriteCities.first?.name, "New York", "The first city should be New York")
    }

    func testLoadFavoriteCities_WhenErrorOccurs_ShouldSetErrorMessage() {
        // Given
        mockFavoritesUseCase.shouldThrowError = true

        // When
        viewModel.loadFavoriteCities()

        // Then
        XCTAssertNotNil(viewModel.errorMessage, "There should be an error message")
        XCTAssertEqual(viewModel.errorMessage, "An error ocurred when trying to fetch favorites. Try again later.")
    }
    
    func testRemoveFromFavorites_ShouldDeleteCity() {
        // Given
        let city = City.mockNewYorkCity
        mockFavoritesUseCase.savedCities = [city]

        // When
        viewModel.removeFromFavorites(city)

        // Then
        XCTAssertFalse(viewModel.favoriteCities.contains { $0.id == city.id }, "The city shouldn't be in favorites")
    }
    
    func testRemoveFromFavorites_WhenErrorOccurs_ShouldSetErrorMessage() {
        // Given
        let city = City.mockChicagoCity
        mockFavoritesUseCase.shouldThrowError = true

        // When
        viewModel.removeFromFavorites(city)

        // Then
        XCTAssertNotNil(viewModel.errorMessage, "There should be an error message")
        XCTAssertEqual(viewModel.errorMessage, "An error ocurred deleting that city, Try again later.")
    }
    
    func testRemoveFromFavorites_ShouldDisableDeleteMode() {
        // Given
        let city = City.mockNewYorkCity
        mockFavoritesUseCase.savedCities = [city]
        viewModel.deleteMode = true

        // When
        viewModel.removeFromFavorites(city)

        // Then
        XCTAssertFalse(viewModel.deleteMode, "The delete mode should be disabled after deleting a city")
    }
    
    func testLatitudeLongitudeLabel_ShouldReturnFormattedString() {
        // When
        let result = viewModel.latitudeLongitudeLabel(lat: 12.3456, lon: -98.7654)

        // Then
        XCTAssertEqual(result, "LAT: 12.3°, LON: -98.8°", "The coordinates label should be formatted correctly")
    }

}
