//
//  WeatherModelMapper.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

class WeatherModelMapper {
    static func mapForecastToPresentation(_ model: ForecastModel) -> Forecast {
        let forecast = model.forecast.map { forecastDate in
            ForecastDay(
                date: forecastDate.date,
                astro: ForecastAstronomy(
                    sunrise: forecastDate.astro.sunrise,
                    sunset: forecastDate.astro.sunset,
                    moonrise: forecastDate.astro.moonrise,
                    moonset: forecastDate.astro.moonset,
                    moonPhase: forecastDate.astro.moonPhase
                ),
                maxTemperature: forecastDate.maxTemperature,
                minTemperature: forecastDate.minTemperature,
                averageTemperature: forecastDate.averageTemperature,
                maxWindSpeed: forecastDate.maxWindSpeed,
                totalRainfall: forecastDate.totalRainfall,
                chanceOfRain: forecastDate.chanceOfRain,
                averageHumidity: forecastDate.averageHumidity,
                condition: forecastDate.condition,
                conditionIcon: forecastDate.conditionIcon,
                uvIndex: forecastDate.uvIndex
            )
        }
        
        return Forecast(
            name: model.name,
            region: model.region,
            country: model.country,
            latitude: model.latitude,
            longitude: model.longitude,
            currentWeather: ForecastCurrentWeather(
                temperature: model.currentWeather.temperature,
                condition: model.currentWeather.condition,
                conditionIcon: model.currentWeather.conditionIcon,
                windSpeed: model.currentWeather.windSpeed,
                windDegree: model.currentWeather.windDegree,
                windDirection: model.currentWeather.windDirection,
                pressure: model.currentWeather.pressure,
                humidity: model.currentWeather.humidity,
                cloudiness: model.currentWeather.cloudiness,
                tempFeelsLike: model.currentWeather.tempFeelsLike,
                windChill: model.currentWeather.windChill,
                heatIndex: model.currentWeather.heatIndex,
                dewPoint: model.currentWeather.dewPoint,
                uvIndex: model.currentWeather.uvIndex,
                gustSpeed: model.currentWeather.gustSpeed
            ),
            forecast: forecast
        )
    }
    
    static func mapCityToPresentation(_ model: CityModel) -> City {
        return City(
            id: model.id,
            name: model.name,
            region: model.region,
            country: model.country,
            latitude: model.latitude,
            longitude: model.longitude,
            url: model.url
        )
    }
}
