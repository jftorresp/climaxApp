//
//  CityForecastViewModel.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import Foundation

class CityForecastViewModel: ObservableObject {
    private let getForecastUseCase: GetForecastByCityUseCase
    @Published var selectedCity: String = ""
    @Published var forecast: Forecast?
    @Published var errorMessage: String?
    
    init(getForecastUseCase: GetForecastByCityUseCase = GetForecastByCityUseCaseImpl()) {
        self.getForecastUseCase = getForecastUseCase
    }
    
    @MainActor
    func getForecast() async throws {
        do {
            self.forecast = try await getForecastUseCase.execute(selectedCity)
            self.errorMessage = nil
        } catch DomainError.noLocationFound {
            self.errorMessage = "No location found."
        } catch {
            self.errorMessage = "Unexpected error occurred."
        }
    }
}
