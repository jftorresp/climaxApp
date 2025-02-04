//
//  SearchCityViewModelTests.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import XCTest
@testable import climaxApp

final class SearchCityViewModelTests: XCTestCase {
    var viewModel: SearchCityViewModel!
    var mockSearchCityUseCase: MockSearchCityUseCase!

    override func setUp() {
        super.setUp()
        mockSearchCityUseCase = MockSearchCityUseCase()
        viewModel = SearchCityViewModel(searchCityUseCase: mockSearchCityUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockSearchCityUseCase = nil
        super.tearDown()
    }

    func testSearchCityByName_ShouldReturnCities() async throws {
        // Given
        viewModel.searchText = "Chi"
        
        // When
        try await viewModel.searchCityByName(name: viewModel.searchText)

        // Then
        XCTAssertFalse(viewModel.cities.isEmpty, "The search should return results")
        XCTAssertEqual(viewModel.cities.count, 2, "Should return 2 cities")
        XCTAssertEqual(viewModel.cities.first?.name, "Chicago", "The first city should be Chicago")
    }

    func testSearchCityByName_WhenNoResults_ShouldSetNoResultsFound() async throws {
        // Given
        viewModel.searchText = "XYZ"
        mockSearchCityUseCase.shouldReturnEmpty = true

        // When
        try await viewModel.searchCityByName(name: viewModel.searchText)

        // Then
        XCTAssertTrue(viewModel.noResultsFound, "Should mark `noResultsFound` as `true`")
        XCTAssertEqual(viewModel.cities.count, 0, "No cities should be in the list")
    }

    func testSearchCityByName_WhenErrorOccurs_ShouldSetErrorMessage() async throws {
        // Given
        viewModel.searchText = "Paris"
        mockSearchCityUseCase.shouldThrowError = true

        // When
        try await viewModel.searchCityByName(name: viewModel.searchText)

        // Then
        XCTAssertNotNil(viewModel.errorMessage, "Should be an error message")
        XCTAssertEqual(viewModel.errorMessage, "No location found, please try another value.")
    }

    func testSearchCityByName_WhenSearchTextIsEmpty_ShouldResetSearch() async throws {
        // Given
        viewModel.searchText = ""

        // When
        try await viewModel.searchCityByName(name: viewModel.searchText)

        // Then
        XCTAssertTrue(viewModel.cities.isEmpty, "The list of cities should be empty")
        XCTAssertFalse(viewModel.noResultsFound, "Shouldn't mark `noResultsFound` as `true`")
    }
    
    func testNoResultsSubTitleLabel_ShouldReturnCorrectMessage() {
        // Given
        viewModel.searchText = "Paris"

        // When
        let result = viewModel.noResultsSubTitleLabel

        // Then
        XCTAssertEqual(result, "No cities found for \"Paris\".", "Should return the correct message")
    }
}
