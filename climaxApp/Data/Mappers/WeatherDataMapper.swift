//
//  WeatherDataMapper.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

class WeatherDataMapper {
    static func mapForecastToDomain(_ response: ForecastResponse) -> ForecastModel {
        let forecast = response.forecast.forecastday.map { forecastDate in
            ForecastDayModel(
                date: forecastDate.date,
                astro: ForecastAstroModel(
                    sunrise: forecastDate.astro.sunrise,
                    sunset: forecastDate.astro.sunset,
                    moonrise: forecastDate.astro.moonrise,
                    moonset: forecastDate.astro.moonset,
                    moonPhase: forecastDate.astro.moon_phase
                ),
                maxTemperature: forecastDate.day.maxtemp_c,
                minTemperature: forecastDate.day.mintemp_c,
                averageTemperature: forecastDate.day.avgtemp_c,
                maxWindSpeed: forecastDate.day.maxwind_kph,
                totalRainfall: forecastDate.day.totalprecip_mm,
                chanceOfRain: forecastDate.day.daily_chance_of_rain,
                averageHumidity: forecastDate.day.avghumidity,
                condition: forecastDate.day.condition.text,
                conditionIcon: forecastDate.day.condition.icon,
                uvIndex: forecastDate.day.uv
            )
        }
        
        return ForecastModel(
            name: response.location.name,
            region: response.location.region,
            country: response.location.country,
            latitude: response.location.lat,
            longitude: response.location.lon,
            currentWeather: ForecastCurrentWeatherModel(
                temperature: response.current.temp_c,
                condition: response.current.condition.text,
                conditionIcon: response.current.condition.icon,
                windSpeed: response.current.wind_kph,
                windDegree: response.current.wind_degree,
                windDirection: response.current.wind_dir,
                pressure: response.current.pressure_in,
                humidity: response.current.humidity,
                cloudiness: response.current.cloud,
                tempFeelsLike: response.current.feelslike_c,
                windChill: response.current.windchill_c,
                heatIndex: response.current.heatindex_c,
                dewPoint: response.current.dewpoint_c,
                uvIndex: response.current.uv,
                gustSpeed: response.current.gust_kph
            ),
            forecast: forecast
        )
    }
    
    static func mapCityToDomain(_ response: CityResponse) -> CityModel {
        return CityModel(
            id: response.id,
            name: response.name,
            region: response.region,
            country: response.country,
            latitude: response.lat,
            longitude: response.lon,
            url: response.url
        )
    }
}
