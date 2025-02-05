//
//  SearchCityUseCaseTests.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 4/02/25.
//

import XCTest
@testable import climaxApp

final class SearchCityUseCaseTests: XCTestCase {
    var useCase: SearchCityUseCaseImpl!
    var mockRepository: MockWeatherRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        useCase = SearchCityUseCaseImpl(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testExecute_WhenQueryMatchesCities_ShouldReturnFilteredCities() async throws {
        // Given
        let query = "new"

        // When
        let cities = try await useCase.execute(query)

        // Then
        XCTAssertEqual(cities.count, 1, "It should return the citites that match the query")
        XCTAssertEqual(cities.first?.name, "New York", "The returned city should be'New York'")
    }

    
    func testExecute_WhenQueryHasNoMatches_ShouldReturnEmptyArray() async throws {
        // Given
        let query = "xyz"

        // When
        let cities = try await useCase.execute(query)

        // Then
        XCTAssertEqual(cities.count, 0, "Should return an empty array if no coincidences")
    }
    
    func testExecute_WhenQueryIsEmpty_ShouldReturnEmptyArray() async throws {
        // When
        let cities = try await useCase.execute("")

        // Then
        XCTAssertEqual(cities.count, 0, "Should return an empty array")
    }
}
