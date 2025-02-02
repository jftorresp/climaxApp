//
//  CityForecastView.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import SwiftUI

struct CityForecastView: View {
    @StateObject var viewModel: CityForecastViewModel
    
    init(viewModel: CityForecastViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.brandBlue)
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            content
                .onAppear {
                    Task {
                        try await viewModel.getForecast()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SearchCityView(selectedCity: $viewModel.selectedCity, viewModel: SearchCityViewModel())
                        } label: {
                            Image.searchIcon
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20)
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            
                        } label: {
                            Image.starIcon
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 20)
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
    
    var content: some View {
        ZStack {
            Color.brandBlue
                .ignoresSafeArea(.all)
            VStack {
                if let forecast = viewModel.forecast {
                    ForecastHeader(forecast)
                    ScrollView(showsIndicators: false) {
                        HStack(spacing: 12) {
                            if let currentDayForecast = viewModel.currentDayForecast {
                                ForecastInfoCard(
                                    title: "AVERAGE",
                                    additionalInfo: viewModel.averageTemperatureText,
                                    icon: "chart.line.uptrend.xyaxis",
                                    value: "\(currentDayForecast.averageTemperature.toIntString())°")
                            }
                            ForecastInfoCard(
                                title: "FEELS LIKE",
                                additionalInfo: viewModel.feelsLikeTemperatureText,
                                icon: "thermometer.medium",
                                value: "\(forecast.currentWeather.tempFeelsLike.toIntString())°")

                        }

                        ThreeDayForecast(forecast)
                        
                        HStack(spacing: 12) {
                            ForecastInfoCard(
                                title: "UV INDEX",
                                additionalInfo: viewModel.uvIndexText,
                                icon: "sun.max.fill",
                                value: "\(forecast.currentWeather.uvIndex.toIntString())")
                            ForecastInfoCard(
                                title: "HUMIDITY",
                                additionalInfo: viewModel.dewPointText,
                                icon: "humidity.fill",
                                value: "\(forecast.currentWeather.humidity)%")
                        }
                        
                        ForecastWindCard(forecast: forecast)
                    }
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: Subviews

extension CityForecastView {
    @ViewBuilder
    func ForecastHeader(_ forecast: Forecast) -> some View {
        VStack {
            Text("\(forecast.name)")
                .font(.system(size: 36))
                .foregroundColor(.white)
                .shadow(radius: 5)
            Text("\(viewModel.currentTemparature)°")
                .font(.system(size: 90, weight: .thin))
                .foregroundColor(.white)
                .shadow(radius: 5)
            Text("\(forecast.currentWeather.condition)")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.lightYellow)
            
            if let currentDayForecast = viewModel.currentDayForecast {
                HStack {
                    Text("MAX:\(currentDayForecast.maxTemperature.toIntString())°")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    Text("MIN:\(currentDayForecast.minTemperature.toIntString())°")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 50)
    }
    
    @ViewBuilder
    func ForecastInfoCard(title: String, additionalInfo: String? = nil, icon: String, value: String) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(height: 12)
                    Text(title)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .opacity(0.5)
                Text(value)
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                if let additionalInfo = additionalInfo {
                    Text(additionalInfo)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandDarkBlue)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    func ThreeDayForecast(_ forecast: Forecast) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 16)
                    Text("3-DAY FORECAST")
                        .foregroundColor(.white)
                }
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white.opacity(0.3))
                
                VStack(alignment: .leading) {
                    ForEach(Array(forecast.forecast.enumerated()), id: \.offset) { index, forecastDay in
                        VStack {
                            HStack {
                                Text("\(viewModel.getWeekdayLabel(from: forecastDay.date))")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .leading)
                                VStack {
                                    viewModel.cloudRainIcon(forecast: forecastDay)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: 22)
                                        .padding(.horizontal, 16)
                                    if forecastDay.chanceOfRain > 0 {
                                        Text("\(forecastDay.chanceOfRain)%")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                    }
                                }

                                TemperatureRangePerDay(forecast: forecastDay)
                                
                            }
                            .padding(.top, 6)
                            .frame(maxWidth: .infinity)
                            if index < forecast.forecast.count - 1 {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.white.opacity(0.3))
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .background(Color.brandDarkBlue)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    func TemperatureRangePerDay(forecast: ForecastDay) -> some View {
        HStack {
            Text("\(forecast.minTemperature.toIntString())°")
                .font(.system(size: 16))
                .foregroundColor(.white)
            ProgressView(value: forecast.averageTemperature, total: forecast.maxTemperature)
                .foregroundColor(.yellow)
            Text("\(forecast.maxTemperature.toIntString())°")
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    func ForecastWindCard(forecast: Forecast) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "wind")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(height: 12)
                    Text("WIND")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .opacity(0.5)
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Wind")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(forecast.currentWeather.windSpeed.toIntString()) km/h")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                    
                    HStack {
                        Text("Gusts")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(forecast.currentWeather.gustSpeed.toIntString()) km/h")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                    
                    HStack {
                        Text("Direction")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(forecast.currentWeather.windDegree)° \(forecast.currentWeather.windDirection)")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandDarkBlue)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    CityForecastView(viewModel: CityForecastViewModel())
}
