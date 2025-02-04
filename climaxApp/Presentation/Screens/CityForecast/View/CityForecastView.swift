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
                    viewModel.loadFavoriteCities()
                    Task {
                        try await viewModel.getForecast()
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
    
    var content: some View {
        GeometryReader { geometry in
            let newIsLandscape = geometry.size.width > geometry.size.height
            
            ZStack {
                Color.brandBlue
                    .ignoresSafeArea(.all)
                VStack {
                    if !viewModel.isLoading {
                        topBarView
                            .if(viewModel.isLandscape, transform: { view in
                                view
                                    .padding(.top, Constants.GeneralSizing.landscapeTopPadding)
                            })
                    }
                    
                    if viewModel.isLoading {
                        Spacer()
                        loadingView
                        Spacer()
                    } else if viewModel.selectedCity == nil {
                        Spacer()
                        EventView(
                            title: viewModel.noCityTitleLabel,
                            subtitle: viewModel.noCitySubtitleLabel,
                            image: .cloudSunImg
                        )
                        Spacer()
                    } else {
                        if let forecast = viewModel.forecast {
                            if !viewModel.isLandscape {
                                PortraitForecastView(forecast)
                            } else {
                                LandscapeForecastView(forecast)
                            }
                        }
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Spacer()
                        EventView(
                            title: viewModel.errorTitleLabel,
                            subtitle: errorMessage,
                            image: .cloudAngryImg
                        )
                        Spacer()
                    }
                }
                .padding(.horizontal, Sizing.small.rawValue)
                
                bottomBarView
            }
            .onAppear { viewModel.isLandscape = newIsLandscape }
            .onChange(of: newIsLandscape) { newValue in
                viewModel.isLandscape = newValue
            }
        }
    }
}

// MARK: Subviews

extension CityForecastView {
    var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            .scaleEffect(Constants.GeneralSizing.progressScaleEffect)
    }
    
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
                            .frame(width: Constants.CityForecast.smallIconWidth)
                    } else {
                        Image.starIcon
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: Constants.CityForecast.smallIconWidth)
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
                    .frame(width: Constants.CityForecast.smallIconWidth)
            }
        }
    }
    
    var bottomBarView: some View {
        VStack {
            if !viewModel.isLandscape {
                Rectangle()
                    .foregroundColor(.white.opacity(Constants.CityForecast.rectangleOpacity))
                    .frame(height: Sizing.xxxxTiny.rawValue)
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
                        .frame(width: Constants.CityForecast.smallIconWidth)
                }
                .disabled(true)

                Spacer()
                
                Image.appLongLogo
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.CityForecast.appLongLogoWidth)
                
                Spacer()
                
                NavigationLink {
                    FavoritesView(viewModel: FavoritesViewModel(), selectedFavoriteCity: $viewModel.selectedCity)
                } label: {
                    Image.starSquareIcon
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: Constants.CityForecast.smallIconWidth)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, Sizing.xxxxSmall.rawValue)
            .padding(.bottom, !viewModel.isLandscape ? Constants.CityForecast.bottomBarPortraitPadding : Sizing.xxxxSmall.rawValue)
            .padding(.horizontal, Sizing.small.rawValue)
        }
        .background(Color.darkBlue.opacity(!viewModel.isLandscape ? Constants.CityForecast.portraitBgOpacity : Constants.CityForecast.landscapeBgOpacity))
        .if(viewModel.isLandscape) { view in
            view
                .clipShape(RoundedRectangle(cornerRadius: Sizing.small.rawValue))
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .if(!viewModel.isLandscape) { frame in
            frame
                .ignoresSafeArea(.all)
        }
    }

    @ViewBuilder
    func EventView(title: String, subtitle: String, image: Image) -> some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: Constants.CityForecast.eventImageWidth)
            Text(title)
                .font(.system(size: FontSize.p36.rawValue, weight: .bold))
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: FontSize.p16.rawValue))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(Constants.CityForecast.textOpacity)
        }
        .padding(.horizontal, Sizing.small.rawValue)
        .if(viewModel.isLandscape) { view in
            view
                .padding(.bottom, Constants.CityForecast.eventLandscapeBottomPadding)
        }
    }
    
    @ViewBuilder
    func ForecastView(_ forecast: Forecast) -> some View {
        ForecastHeader(forecast)
        Spacer()
        ScrollView(showsIndicators: false) {
            HStack(spacing: Sizing.xxxxSmall.rawValue) {
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
            
            HStack(spacing: Sizing.xxxxSmall.rawValue) {
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
    
    @ViewBuilder
    func LandscapeForecastView(_ forecast: Forecast) -> some View {
        HStack {
            ForecastView(forecast)
        }
    }
    
    @ViewBuilder
    func PortraitForecastView(_ forecast: Forecast) -> some View {
        VStack {
            ForecastView(forecast)
        }
    }
    
    @ViewBuilder
    func ForecastHeader(_ forecast: Forecast) -> some View {
        VStack {
            Text(forecast.name)
                .font(.system(size: FontSize.p36.rawValue))
                .foregroundColor(.white)
                .shadow(radius: Constants.GeneralSizing.shadowRadius)
            Text(viewModel.celsiusLabel(viewModel.currentTemperature))
                .font(.system(size: FontSize.p90.rawValue, weight: .thin))
                .foregroundColor(.white)
                .shadow(radius: Constants.GeneralSizing.shadowRadius)
            Text("\(forecast.currentWeather.condition)")
                .font(.system(size: FontSize.p20.rawValue, weight: .medium))
                .foregroundColor(.lightYellow)
            
            if let currentDayForecast = viewModel.currentDayForecast {
                HStack {
                    Text(viewModel.maxTempLabel(currentDayForecast.maxTemperature.toIntString()))
                        .font(.system(size: FontSize.p20.rawValue))
                        .foregroundColor(.white)
                        .shadow(radius: Constants.GeneralSizing.shadowRadius)
                    Text(viewModel.minTempLabel(currentDayForecast.minTemperature.toIntString()))
                        .font(.system(size: FontSize.p20.rawValue))
                        .foregroundColor(.white)
                        .shadow(radius: Constants.GeneralSizing.shadowRadius)
                }
            }
        }
        .padding(.top, Sizing.small.rawValue)
        .padding(.bottom, Sizing.large.rawValue)
        .if(viewModel.isLandscape) { view in
            view.frame(width: Constants.CityForecast.headerLandscapeWidth)
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
                        .frame(height: Constants.CityForecast.headerCardImageHeight)
                    Text(title)
                        .font(.system(size: FontSize.p12.rawValue))
                        .foregroundColor(.white)
                }
                .opacity(Constants.CityForecast.rectangleOpacity)
                Text(value)
                    .font(.system(size: FontSize.p36.rawValue))
                    .foregroundColor(.white)
                if let additionalInfo = additionalInfo {
                    Text(additionalInfo)
                        .font(.system(size: FontSize.p14.rawValue))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, Sizing.small.rawValue)
            .padding(.horizontal, Sizing.xxSmall.rawValue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandDarkBlue)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CityForecast.cardCornerRadius))
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
                        .opacity(Constants.CityForecast.forecastIconOpacity)
                        .scaledToFit()
                        .frame(width: Constants.CityForecast.forecastIconWidth)
                    Text(viewModel.threeDayForecastLabel)
                        .foregroundColor(.white)
                        .opacity(Constants.CityForecast.forecastIconOpacity)
                }
                Rectangle()
                    .frame(height: Sizing.xxxxTiny.rawValue)
                    .foregroundColor(.white.opacity(Constants.CityForecast.forecastRectangleOpacity))
                
                VStack(alignment: .leading) {
                    ForEach(Array(forecast.forecast.enumerated()), id: \.offset) { index, forecastDay in
                        VStack {
                            HStack {
                                Text("\(viewModel.getWeekdayLabel(from: forecastDay.date))")
                                    .font(.system(size: FontSize.p20.rawValue))
                                    .foregroundColor(.white)
                                    .frame(width: Constants.CityForecast.weekdayWidth, alignment: .leading)
                                VStack {
                                    viewModel.cloudRainIcon(forecast: forecastDay)
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: Constants.CityForecast.cloudWidth)
                                        .padding(.horizontal, Sizing.xxSmall.rawValue)
                                    if forecastDay.chanceOfRain > 0 {
                                        Text(viewModel.percentageLabel(forecastDay.chanceOfRain))
                                            .font(.system(size: FontSize.p12.rawValue))
                                            .foregroundColor(.white)
                                    }
                                }

                                TemperatureRangePerDay(forecast: forecastDay)
                                
                            }
                            .padding(.top, Sizing.xxTiny.rawValue)
                            .frame(maxWidth: .infinity)
                            if index < forecast.forecast.count - 1 {
                                Rectangle()
                                    .frame(height: Sizing.xxxxTiny.rawValue)
                                    .foregroundColor(.white.opacity(Constants.CityForecast.forecastRectangleOpacity))
                            }
                        }
                    }
                }
            }
            .padding(.vertical, Sizing.xxxxSmall.rawValue)
            .padding(.horizontal, Sizing.xxSmall.rawValue)
        }
        .background(Color.brandDarkBlue)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CityForecast.cardCornerRadius))
    }
    
    @ViewBuilder
    func TemperatureRangePerDay(forecast: ForecastDay) -> some View {
        HStack {
            Text(viewModel.celsiusLabel(forecast.minTemperature.toIntString()))
                .font(.system(size: FontSize.p16.rawValue))
                .foregroundColor(.white)
            ProgressView(value: max(min(forecast.averageTemperature, forecast.maxTemperature), 0), total: forecast.maxTemperature)
                .foregroundColor(.yellow)
            Text(viewModel.celsiusLabel(forecast.maxTemperature.toIntString()))
                .font(.system(size: FontSize.p16.rawValue))
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
                        .frame(height: Constants.CityForecast.headerCardImageHeight)
                    Text(viewModel.windTitle)
                        .font(.system(size: FontSize.p12.rawValue))
                        .foregroundColor(.white)
                }
                .opacity(Constants.CityForecast.forecastWindOpacity)
                
                VStack(spacing: Sizing.xxSmall.rawValue) {
                    HStack {
                        Text(viewModel.windLabel)
                            .font(.system(size: FontSize.p16.rawValue))
                            .foregroundColor(.white)
                        Spacer()
                        Text(viewModel.speedItemLabel(forecast.currentWeather.windSpeed.toIntString()))
                            .font(.system(size: FontSize.p16.rawValue))
                            .foregroundColor(.white)
                            .opacity(Constants.CityForecast.forecastWindOpacity)
                    }
                    
                    HStack {
                        Text(viewModel.gustsLabel)
                            .font(.system(size: FontSize.p16.rawValue))
                            .foregroundColor(.white)
                        Spacer()
                        Text(viewModel.speedItemLabel(forecast.currentWeather.gustSpeed.toIntString()))
                            .font(.system(size: FontSize.p16.rawValue))
                            .foregroundColor(.white)
                            .opacity(Constants.CityForecast.forecastWindOpacity)
                    }
                    
                    HStack {
                        Text(viewModel.windDirectionLabel)
                            .font(.system(size: FontSize.p16.rawValue))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(forecast.currentWeather.windDegree)° \(forecast.currentWeather.windDirection)")
                            .font(.system(size: FontSize.p16.rawValue))
                            .foregroundColor(.white)
                            .opacity(Constants.CityForecast.forecastWindOpacity)
                    }
                }
            }
            .padding(.vertical, Sizing.xxxxSmall.rawValue)
            .padding(.horizontal, Sizing.xxSmall.rawValue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandDarkBlue)
        .clipShape(RoundedRectangle(cornerRadius: Constants.CityForecast.cardCornerRadius))
        .padding(.bottom, Constants.CityForecast.contentBottomPadding)
    }
}

#Preview {
    CityForecastView(viewModel: CityForecastViewModel())
}
