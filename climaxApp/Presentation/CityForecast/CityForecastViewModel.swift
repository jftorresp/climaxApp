//
//  CityForecastViewModel.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import Foundation
import SwiftUI

class CityForecastViewModel: ObservableObject {
    private let getForecastUseCase: GetForecastByCityUseCase
    @Published var selectedCity: String = ""
    @Published var forecast: Forecast?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var currentTemparature: String {
        guard let forecast else { return "-°" }
        return forecast.currentWeather.temperature.toIntString()
    }
    
    var currentDayForecast: ForecastDay? {
        guard let forecast else { return nil }
        return forecast.forecast[0]
    }
    
    var averageTemperatureText: String {
        guard let currentDayForecast = currentDayForecast else { return "" }
        if currentDayForecast.averageTemperature < currentDayForecast.maxTemperature  {
            return "above average daily hight"
        } else {
            return "below average daily hight"
        }
    }
    
    var feelsLikeTemperatureText: String {
        guard let forecast else { return "-" }
        if (forecast.currentWeather.tempFeelsLike == forecast.currentWeather.temperature + 1) || (forecast.currentWeather.tempFeelsLike == forecast.currentWeather.temperature - 1) {
            return "Similar to the current temperature."
        } else if (forecast.currentWeather.tempFeelsLike > forecast.currentWeather.temperature + 2) {
            return "The temperature feels like it is higher."
        } else {
            return "The temperature feels cooler."
        }
    }
    
    var uvIndexText: String {
        guard let forecast else { return "" }
        if forecast.currentWeather.uvIndex <= 2 {
            return "Low. Use sun protection."
        } else if forecast.currentWeather.uvIndex >= 3 && forecast.currentWeather.uvIndex <= 5 {
            return "Moderate. Use sun protection."
        } else if forecast.currentWeather.uvIndex >= 6 && forecast.currentWeather.uvIndex <= 7  {
            return "High. Use sun protection."
        }else if forecast.currentWeather.uvIndex >= 8 && forecast.currentWeather.uvIndex <= 10  {
            return "Very High. Use sun protection."
        } else {
            return "Extreme. Use sun protection."
        }
    }
    
    var dewPointText: String {
        guard let forecast else { return "" }
        return "The dew point is \(forecast.currentWeather.dewPoint.toIntString())° right now."
    }
    
    init(getForecastUseCase: GetForecastByCityUseCase = GetForecastByCityUseCaseImpl()) {
        self.getForecastUseCase = getForecastUseCase
    }
    
    @MainActor
    func getForecast() async throws {
        self.isLoading = true
        do {
            self.forecast = try await getForecastUseCase.execute(selectedCity)
            self.isLoading = false
            self.errorMessage = nil
        } catch DomainError.noLocationFound {
            self.errorMessage = "No location found."
            self.isLoading = false
        } catch {
            self.errorMessage = "An unexpected error occurred."
            self.isLoading = false
        }
    }
    
    func cloudRainIcon(forecast: ForecastDay) -> Image {
        if forecast.chanceOfRain == 0 {
            return Image.cloudIcon
        } else if forecast.chanceOfRain > 0 && forecast.chanceOfRain <= 33 {
            return Image.cloudDrizzleIcon
        } else if forecast.chanceOfRain > 33 && forecast.chanceOfRain <= 66 {
            return Image.cloudRainIcon
        } else {
            return .cloudHeavyRainIcon
        }
    }
    
    func getWeekdayLabel(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatter.date(from: dateString) else { return "-" }

        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        }

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE"
        
        return weekdayFormatter.string(from: date)
    }
}

// MARK: Labels

extension CityForecastViewModel {
    var averageTitle: String {
        return "AVERAGE"
    }
    
    var feelsLikeTitle: String {
        return "FEELS LIKE"
    }
    
    var uvIndexTitle: String {
        return "UV INDEX"
    }
    
    var humidityTitle: String {
        return "HUMIDITY"
    }
    
    var windTitle: String {
        return "WIND"
    }
    
    var windLabel: String {
        return "Wind"
    }
    
    var gustsLabel: String {
        return "Gusts"
    }
    
    var windDirectionLabel: String {
        return "Direction"
    }
    
    var threeDayForecastLabel: String {
        return "3-DAY FORECAST"
    }
    
    var errorTitleLabel: String {
        return "Oh no!"
    }
    
    var noCityTitleLabel: String {
        return "No city selected"
    }
    
    var noCitySubtitleLabel: String {
        return "Please search for a city to view the forecast."
    }
    
    func maxTempLabel(_ value: String) -> String {
        return "MAX: \(value)°"
    }
    
    func minTempLabel(_ value: String) -> String {
        return "MIN: \(value)°"
    }
    
    func speedItemLabel(_ value: String) -> String {
        return "\(value) km/h"
    }
    
    func percentageLabel(_ value: Int) -> String {
        return "\(value)%"
    }
    
    func celsiusLabel(_ value: String) -> String {
        return "\(value)°"
    }
}
