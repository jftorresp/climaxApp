//
//  SearchCityUseCase.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

protocol SearchCityUseCase {
    func execute(_ query: String) async throws -> [City]
}

class SearchCityUseCaseImpl: SearchCityUseCase {
    let repository: WeatherRepository
    
    init(repository: WeatherRepository = WeatherRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(_ query: String) async throws -> [City] {
        let model = try await repository.searchCity(query)
        let cities = model.map { cityModel in
            WeatherModelMapper.mapCityToPresentation(cityModel)
        }
        return cities
    }
}
