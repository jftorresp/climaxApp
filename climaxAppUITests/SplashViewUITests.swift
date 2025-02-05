//
//  SplashViewUITests.swift
//  climaxAppUITests
//
//  Created by Juan Felipe Torres on 4/02/25.
//

import XCTest

final class SplashViewUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func testDebug_PrintUIHierarchy() {
        let app = XCUIApplication()
        app.launch()

        sleep(2)
        print("UI Hierarchy", app.debugDescription)
    }

    func testSplashView_ShowsLogoAndLoader() {
        let app = XCUIApplication()
        app.launchArguments.append("UITestMode")
        app.launch()
        
        let splashView = app.otherElements["SplashView"]
        XCTAssertTrue(splashView.waitForExistence(timeout: 5), "SplashView is not present")

        let logo = app.images["appLogo"]
        XCTAssertTrue(logo.exists, "Logo is not present in SplashView")

        let appNameLabel = app.staticTexts["appName"]
        XCTAssertTrue(appNameLabel.exists, "App name is not present in SplashView")

        let loader = app.activityIndicators["splashProgressView"]
        XCTAssertTrue(loader.exists, "Loader is not present in SplashView")
    }
    
    func testSplashView_NavigatesToCityForecastView() {
        let splashScreen = app.otherElements["SplashView"]
        XCTAssertTrue(splashScreen.waitForExistence(timeout: 1.5), "Splashview is not present in the app")

        let cityForecastView = app.otherElements["CityForecastView"]
        XCTAssertTrue(cityForecastView.waitForExistence(timeout: 6), "Failed to navigate to CityForecastView after splash")
    }
}
