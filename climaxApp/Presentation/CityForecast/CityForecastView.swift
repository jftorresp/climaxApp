//
//  CityForecastView.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import SwiftUI

struct CityForecastView: View {
    @StateObject var viewModel: CityForecastViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.brandDarkBlue
                VStack {
                    if let forecast = viewModel.forecast {
                        Text("\(forecast.name)")
                            .foregroundColor(.white)
                        Text("\(forecast.country)")
                            .foregroundColor(.white)
                    }
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.white)
                    }
                }
            }
            .ignoresSafeArea(.all)
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
            }
        }
    }
}

#Preview {
    CityForecastView(viewModel: CityForecastViewModel())
}
