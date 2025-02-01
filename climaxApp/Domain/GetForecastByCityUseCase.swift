//
//  GetForecastUseCase.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

protocol GetForecastByCityUseCase {
    func execute(_ city: String) async throws -> Forecast
}

class GetForecastByCityUseCaseImpl: GetForecastByCityUseCase {
    let repository: WeatherRepository
    
    init(repository: WeatherRepository = WeatherRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(_ city: String) async throws -> Forecast {
        let model = try await repository.getForecastByCity(city)
        return WeatherModelMapper.mapForecastToPresentation(model)
    }
}
