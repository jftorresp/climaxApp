//
//  FavoritesUseCase.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import Foundation

protocol FavoritesUseCase {
    func saveFavoriteCity(_ city: City) throws
    func fetchfavoritesCities() throws -> [City]
    func deleteFavoriteCity(_ city: City) throws
}

class FavoritesUseCaseImpl: FavoritesUseCase {
    let repository: FavoritesRepository
    
    init(repository: FavoritesRepository = FavoritesRepositoryImpl()) {
        self.repository = repository
    }
    
    func saveFavoriteCity(_ city: City) throws {
        let cityModel = FavoritesMapper.mapFavoriteCityToDomain(city)
        try repository.saveFavoriteCity(cityModel)
    }
    
    func fetchfavoritesCities() throws -> [City] {
        let citiesModel = try repository.fetchfavoritesCities()
        let cities = citiesModel.map { cityModel in
            WeatherModelMapper.mapCityToPresentation(cityModel)
        }
        return cities
    }
    
    func deleteFavoriteCity(_ city: City) throws {
        let cityModel = FavoritesMapper.mapFavoriteCityToDomain(city)
        try repository.deleteFavoriteCity(cityModel)
    }
}
