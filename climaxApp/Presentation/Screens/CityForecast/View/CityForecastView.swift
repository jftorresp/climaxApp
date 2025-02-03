//
//  CityForecastView.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import SwiftUI

struct CityForecastView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
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
                    viewModel.loadFavoriteCities()
                    Task {
                        try await viewModel.getForecast()
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
                if !viewModel.isLoading {
                    topBarView
                        .if(sizeClass != .compact, transform: { view in
                            view
                                .padding(.top, 30)
                        })
                }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if viewModel.selectedCity == nil {
                    Spacer()
                    noSelectedCityView
                    Spacer()
                } else {
                    if let forecast = viewModel.forecast {
                        if sizeClass == .compact {
                            ForecastView(forecast)
                        } else {
                            LandscapeForecastView(forecast)
                        }
                    }
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    ErrorView(error: errorMessage)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            
            bottomBarView
        }
    }
}

// MARK: Subviews

extension CityForecastView {
    var topBarView: some View {
        HStack {
            Button {
                if let selectedCity = viewModel.selectedCity {
                    if viewModel.isFavorite(selectedCity) {
                        viewModel.removeFromFavorites(selectedCity)
                    } else {
                        viewModel.addToFavorites(selectedCity)
                    }
                }
            } label: {
                if let selectedCity = viewModel.selectedCity {
                    if viewModel.isFavorite(selectedCity) {
                        Image.starFillIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20)
                    } else {
                        Image.starIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20)
                    }
                }
            }
            Spacer()
            
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
    }
    
    var bottomBarView: some View {
        VStack {
            if sizeClass == .compact {
                Rectangle()
                    .foregroundColor(.white.opacity(0.5))
                    .frame(height: 1)
            }
            HStack {
                NavigationLink {
                    EmptyView()
                } label: {
                    Image.mapIcon
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20)
                }
                .disabled(true)

                Spacer()
                
                Image.appLongLogo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                
                Spacer()
                
                NavigationLink {
                    FavoritesView(viewModel: FavoritesViewModel(), selectedFavoriteCity: $viewModel.selectedCity)
                } label: {
                    Image.starSquareIcon
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 12)
            .padding(.bottom, sizeClass == .compact ? 50 : 12)
            .padding(.horizontal, 20)
        }
        .background(Color.darkBlue.opacity(sizeClass == .compact ? 1 : 0.7))
        .if(sizeClass != .compact) { view in
            view
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .if(sizeClass == .compact) { frame in
            frame
                .ignoresSafeArea(.all)
        }
    }
    
    var noSelectedCityView: some View {
        VStack {
            Image.cloudSunImg
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Text(viewModel.noCityTitleLabel)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            Text(viewModel.noCitySubtitleLabel)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .opacity(0.6)
        }
        .padding(.horizontal, 20)
    }
    
    func ErrorView(error: String) -> some View {
        VStack {
            Image.cloudAngryImg
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Text(viewModel.errorTitleLabel)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
            Text(error)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .opacity(0.6)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func LandscapeForecastView(_ forecast: Forecast) -> some View {
        HStack {
            ForecastHeader(forecast)
            Spacer()
            ScrollView(showsIndicators: false) {
                HStack(spacing: 12) {
                    if let currentDayForecast = viewModel.currentDayForecast {
                        ForecastInfoCard(
                            title: viewModel.averageTitle,
                            additionalInfo: viewModel.averageTemperatureText,
                            icon: .chartIcon,
                            value: viewModel.celsiusLabel(currentDayForecast.averageTemperature.toIntString())
                        )
                    }
                    ForecastInfoCard(
                        title: viewModel.feelsLikeTitle,
                        additionalInfo: viewModel.feelsLikeTemperatureText,
                        icon: .thermometerIcon,
                        value: viewModel.celsiusLabel(forecast.currentWeather.tempFeelsLike.toIntString())
                    )
                }

                ThreeDayForecast(forecast)
                
                HStack(spacing: 12) {
                    ForecastInfoCard(
                        title: viewModel.uvIndexTitle,
                        additionalInfo: viewModel.uvIndexText,
                        icon: .sunMaxIcon,
                        value: "\(forecast.currentWeather.uvIndex.toIntString())")
                    ForecastInfoCard(
                        title: viewModel.humidityTitle,
                        additionalInfo: viewModel.dewPointText,
                        icon: .humidityIcon,
                        value: viewModel.percentageLabel(forecast.currentWeather.humidity))
                }
                
                ForecastWindCard(forecast: forecast)
            }
        }
    }
    
    @ViewBuilder
    func ForecastView(_ forecast: Forecast) -> some View {
        VStack {
            ForecastHeader(forecast)
            ScrollView(showsIndicators: false) {
                HStack(spacing: 12) {
                    if let currentDayForecast = viewModel.currentDayForecast {
                        ForecastInfoCard(
                            title: viewModel.averageTitle,
                            additionalInfo: viewModel.averageTemperatureText,
                            icon: .chartIcon,
                            value: viewModel.celsiusLabel(currentDayForecast.averageTemperature.toIntString())
                        )
                    }
                    ForecastInfoCard(
                        title: viewModel.feelsLikeTitle,
                        additionalInfo: viewModel.feelsLikeTemperatureText,
                        icon: .thermometerIcon,
                        value: viewModel.celsiusLabel(forecast.currentWeather.tempFeelsLike.toIntString())
                    )
                }

                ThreeDayForecast(forecast)
                
                HStack(spacing: 12) {
                    ForecastInfoCard(
                        title: viewModel.uvIndexTitle,
                        additionalInfo: viewModel.uvIndexText,
                        icon: .sunMaxIcon,
                        value: "\(forecast.currentWeather.uvIndex.toIntString())")
                    ForecastInfoCard(
                        title: viewModel.humidityTitle,
                        additionalInfo: viewModel.dewPointText,
                        icon: .humidityIcon,
                        value: viewModel.percentageLabel(forecast.currentWeather.humidity))
                }
                
                ForecastWindCard(forecast: forecast)
            }
        }
    }
    
    @ViewBuilder
    func ForecastHeader(_ forecast: Forecast) -> some View {
        VStack {
            Text(forecast.name)
                .font(.system(size: 36))
                .foregroundColor(.white)
                .shadow(radius: 5)
            Text(viewModel.celsiusLabel(viewModel.currentTemparature))
                .font(.system(size: 90, weight: .thin))
                .foregroundColor(.white)
                .shadow(radius: 5)
            Text("\(forecast.currentWeather.condition)")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.lightYellow)
            
            if let currentDayForecast = viewModel.currentDayForecast {
                HStack {
                    Text(viewModel.maxTempLabel(currentDayForecast.maxTemperature.toIntString()))
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    Text(viewModel.minTempLabel(currentDayForecast.minTemperature.toIntString()))
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 40)
        .if(sizeClass != .compact) { view in
            view.frame(width: 250)
        }
    }
    
    @ViewBuilder
    func ForecastInfoCard(title: String, additionalInfo: String? = nil, icon: Image, value: String) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    icon
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
                    Image.calendarIcon
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .scaledToFit()
                        .frame(width: 16)
                    Text(viewModel.threeDayForecastLabel)
                        .foregroundColor(.white)
                        .opacity(0.5)
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
                                        Text(viewModel.percentageLabel(forecastDay.chanceOfRain))
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
            Text(viewModel.celsiusLabel(forecast.minTemperature.toIntString()))
                .font(.system(size: 16))
                .foregroundColor(.white)
            ProgressView(value: max(min(forecast.averageTemperature, forecast.maxTemperature), 0), total: forecast.maxTemperature)
                .foregroundColor(.yellow)
            Text(viewModel.celsiusLabel(forecast.maxTemperature.toIntString()))
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder
    func ForecastWindCard(forecast: Forecast) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Image.windIcon
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(height: 12)
                    Text(viewModel.windTitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                .opacity(0.5)
                
                VStack(spacing: 16) {
                    HStack {
                        Text(viewModel.windLabel)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Text(viewModel.speedItemLabel(forecast.currentWeather.windSpeed.toIntString()))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                    
                    HStack {
                        Text(viewModel.gustsLabel)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Text(viewModel.speedItemLabel(forecast.currentWeather.gustSpeed.toIntString()))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }
                    
                    HStack {
                        Text(viewModel.windDirectionLabel)
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
        .padding(.bottom, 80)
    }
}

#Preview {
    CityForecastView(viewModel: CityForecastViewModel())
}
