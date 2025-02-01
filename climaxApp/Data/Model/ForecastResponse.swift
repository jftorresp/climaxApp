//
//  ForecastDataModel.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

struct ForecastResponse: Decodable {
    let location: ForecastLocationResponse
    let current: ForecastCurrentResponse
    let forecast: ForecastDaysResponse
}

struct ForecastLocationResponse: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}

struct ForecastCurrentResponse: Decodable {
    let temp_c: Double
    let condition: ForecastConditionResponse
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_in: Double
    let precip_mm: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let windchill_c: Double
    let heatindex_c: Double
    let dewpoint_c: Double
    let vis_km: Double
    let uv: Double
    let gust_kph: Double
}

struct ForecastDaysResponse: Decodable {
    let forecastday: [ForecastDateResponse]
    
    struct ForecastDateResponse: Decodable {
        let date: String
        let day: ForecastDayResponse
        let astro: ForecastAstroResponse
        
        struct ForecastDayResponse: Decodable {
            let maxtemp_c: Double
            let mintemp_c: Double
            let avgtemp_c: Double
            let maxwind_kph: Double
            let totalprecip_mm: Double
            let avghumidity: Int
            let condition: ForecastConditionResponse
            let uv: Double
        }

        struct ForecastAstroResponse: Decodable {
            let sunrise: String
            let sunset: String
            let moonrise: String
            let moonset: String
            let moon_phase: String
        }
    }
}

struct ForecastConditionResponse: Decodable {
    let text: String
    let icon: String
}
