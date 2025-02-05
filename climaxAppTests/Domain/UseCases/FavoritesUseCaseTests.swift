//
//  FavoritesUseCaseTests.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 4/02/25.
//

import XCTest
@testable import climaxApp

final class FavoritesUseCaseTests: XCTestCase {
    var useCase: FavoritesUseCaseImpl!
    var mockRepository: MockFavoritesRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritesRepository()
        useCase = FavoritesUseCaseImpl(repository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testSaveFavoriteCity_ShouldStoreCityInRepository() throws {
        // Given
        let city = City.mockChicagoCity
        
        // When
        try useCase.saveFavoriteCity(city)
        
        // Then
        XCTAssertEqual(mockRepository.favoriteCities.count, 1, "The city should be saved")
        XCTAssertEqual(mockRepository.favoriteCities.first?.name, "Chicago", "The name of the city should be 'Chicago'")
    }
    
    func testSaveFavoriteCity_WhenRepositoryThrowsError_ShouldThrowError() {
        // Given
        mockRepository.shouldThrowError = true
        let city = City.mockChicagoCity
        
        // When / Then
        XCTAssertThrowsError(try useCase.saveFavoriteCity(city), "Should throw an error if the repository fails")
    }
    
    func testFetchFavoriteCities_ShouldReturnSavedCities() throws {
        // Given
        mockRepository.favoriteCities = [
            CityModel.mockChicagoCity,
            CityModel.mockNewYorkCity
        ]
        
        // When
        let cities = try useCase.fetchfavoritesCities()
        
        // Then
        XCTAssertEqual(cities.count, 2, "Should return 2 favorite cities")
        XCTAssertEqual(cities.first?.name, "Chicago", "The first city should be 'Chicago'")
        XCTAssertEqual(cities.last?.name, "New York", "The second city should be 'New York'")
    }
    
    func testFetchFavoriteCities_WhenRepositoryThrowsError_ShouldThrowError() {
        // Given
        mockRepository.shouldThrowError = true
        
        // When / Then
        XCTAssertThrowsError(try useCase.fetchfavoritesCities(), "Should throw an error if the repository fails")
    }
    
    func testDeleteFavoriteCity_ShouldRemoveCityFromRepository() throws {
        // Given
        let city = City.mockNewYorkCity
        try useCase.saveFavoriteCity(city)
        
        // When
        try useCase.deleteFavoriteCity(city)
        
        // Then
        XCTAssertEqual(mockRepository.favoriteCities.count, 0, "The city should be deleted from the repository")
    }
    
    func testDeleteFavoriteCity_WhenRepositoryThrowsError_ShouldThrowError() {
        // Given
        mockRepository.shouldThrowError = true
        let city = City.mockChicagoCity

        // When / Then
        XCTAssertThrowsError(try useCase.deleteFavoriteCity(city), "Should throw an error if the repository fails")
    }
}
