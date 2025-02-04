//
//  FavoritesRepository.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import Foundation

protocol FavoritesRepository {
    func saveFavoriteCity(_ city: CityModel) throws
    func fetchfavoritesCities() throws -> [CityModel]
    func deleteFavoriteCity(_ city: CityModel) throws
}

class FavoritesRepositoryImpl: FavoritesRepository {
    let dataSource: FavoritesLocalDataSource
    
    init(dataSource: FavoritesLocalDataSource = FavoritesLocalDataSourceImpl()) {
        self.dataSource = dataSource
    }
    
    func saveFavoriteCity(_ city: CityModel) throws {
        do {
            try dataSource.saveFavoriteCity(city)
        } catch {
            throw DomainError.savingError(message: error.localizedDescription)
        }
    }
    
    func fetchfavoritesCities() throws -> [CityModel] {
        do {
            return try dataSource.fetchfavoritesCities()
        } catch {
            throw DomainError.fetchingError(message: error.localizedDescription)
        }
    }
    
    func deleteFavoriteCity(_ city: CityModel) throws {
        do {
            try dataSource.deleteFavoriteCity(city)
        } catch {
            throw DomainError.deletingError(message: error.localizedDescription)
        }
    }
}
