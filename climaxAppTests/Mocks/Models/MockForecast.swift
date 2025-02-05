//
//  MockForecast.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import Foundation
@testable import climaxApp

extension ForecastModel {
    static let mockForecast: ForecastModel = .init(
        name: "Chicago",
        region: "Illinois",
        country: "United States of America",
        latitude: 41.85,
        longitude: -87.65,
        currentWeather: ForecastCurrentWeatherModel(
            temperature: 2.8,
            condition: "Light rain",
            conditionIcon: "//cdn.weatherapi.com/weather/64x64/night/296.png",
            windSpeed: 22.7,
            windDegree: 12,
            windDirection: "NNE",
            pressure: 0.0,
            humidity: 82,
            cloudiness: 100,
            tempFeelsLike: -2.1,
            windChill: -4.1,
            heatIndex: 1.8,
            dewPoint: 0.5,
            uvIndex: 0.0,
            gustSpeed: 32.0
        ),
        forecast: [
            ForecastDayModel(
                date: "2025-02-03",
                astro: ForecastAstroModel(
                    sunrise: "07:01 AM",
                    sunset: "05:09 PM",
                    moonrise: "09:37 AM",
                    moonset: "11:38 PM",
                    moonPhase: "Waxing Crescent"
                ),
                maxTemperature: 7.0,
                minTemperature: 0.4,
                averageTemperature: 2.5,
                maxWindSpeed: 22.7,
                totalRainfall: 0.0,
                chanceOfRain: 0,
                averageHumidity: 94,
                condition: "Overcast",
                conditionIcon: "//cdn.weatherapi.com/weather/64x64/day/122.png",
                uvIndex: 0.4
            )
        ]
    )
}

extension Forecast {
    static let mockForecast: Forecast = .init(
        name: "Chicago",
        region: "Illinois",
        country: "United States of America",
        latitude: 41.85,
        longitude: -87.65,
        currentWeather: ForecastCurrentWeather(
            temperature: 2.8,
            condition: "Light rain",
            conditionIcon: "//cdn.weatherapi.com/weather/64x64/night/296.png",
            windSpeed: 22.7,
            windDegree: 12,
            windDirection: "NNE",
            pressure: 0.0,
            humidity: 82,
            cloudiness: 100,
            tempFeelsLike: -2.1,
            windChill: -4.1,
            heatIndex: 1.8,
            dewPoint: 0.5,
            uvIndex: 0.0,
            gustSpeed: 32.0
        ),
        forecast: [
            ForecastDay(
                date: "2025-02-03",
                astro: ForecastAstronomy(
                    sunrise: "07:01 AM",
                    sunset: "05:09 PM",
                    moonrise: "09:37 AM",
                    moonset: "11:38 PM",
                    moonPhase: "Waxing Crescent"
                ),
                maxTemperature: 7.0,
                minTemperature: 0.4,
                averageTemperature: 2.5,
                maxWindSpeed: 22.7,
                totalRainfall: 0.0,
                chanceOfRain: 0,
                averageHumidity: 94,
                condition: "Overcast",
                conditionIcon: "//cdn.weatherapi.com/weather/64x64/day/122.png",
                uvIndex: 0.4
            )
        ]
    )
}
