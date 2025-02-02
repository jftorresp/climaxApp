//
//  ForecastModel.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

struct ForecastModel {
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let currentWeather: ForecastCurrentWeatherModel
    let forecast: [ForecastDayModel]
}

struct ForecastCurrentWeatherModel {
    let temperature: Double
    let condition: String
    let conditionIcon: String
    let windSpeed: Double
    let windDegree: Int
    let windDirection: String
    let pressure: Double
    let humidity: Int
    let cloudiness: Int
    let tempFeelsLike: Double
    let windChill: Double
    let heatIndex: Double
    let dewPoint: Double
    let uvIndex: Double
    let gustSpeed: Double
}

struct ForecastDayModel {
    let date: String
    let astro: ForecastAstroModel
    let maxTemperature: Double
    let minTemperature: Double
    let averageTemperature: Double
    let maxWindSpeed: Double
    let totalRainfall: Double
    let chanceOfRain: Int
    let averageHumidity: Int
    let condition: String
    let conditionIcon: String
    let uvIndex: Double
}

struct ForecastAstroModel {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moonPhase: String
}

