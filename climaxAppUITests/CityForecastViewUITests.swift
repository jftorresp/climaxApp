//
//  CityForecastViewUITests.swift
//  climaxAppUITests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import XCTest
@testable import climaxApp

final class CityForecastViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testCityForecastView_LoadsSuccessfully() {
        // Given
        let noCityLabel = app.staticTexts["No city selected"]
        
        // When
        let exists = noCityLabel.waitForExistence(timeout: 5)

        // Then
        XCTAssertTrue(exists, "The message 'No city selected' should appear when loading a view without a city selected.")
    }
    
    func testNavigateToSearchCityView() {
        let searchButton = app.descendants(matching: .any).matching(identifier: "searchButton").firstMatch

        XCTAssertTrue(searchButton.waitForExistence(timeout: 5), "No search button found")
        searchButton.tap()

        let searchView = app.otherElements["SearchCityView"]
        XCTAssertTrue(searchView.waitForExistence(timeout: 10), "No navigation to SearchCityView was performed")
    }

    func testLoadingState_ShowsLoader() {
        // Given
        let app = XCUIApplication()
        app.launchArguments.append("UITest_Loading")
        app.launch()

        let loader = app.activityIndicators["progressView"]

        // Then
        XCTAssertTrue(loader.waitForExistence(timeout: 5), "The loader should be visible")
    }
}
