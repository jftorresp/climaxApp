//
//  MockFavoritesRepository.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 4/02/25.
//

import XCTest
@testable import climaxApp

class MockFavoritesRepository: FavoritesRepository {
    var favoriteCities: [CityModel] = []
    var shouldThrowError = false

    func saveFavoriteCity(_ city: CityModel) throws {
        if shouldThrowError {
            throw DomainError.savingError(message: "TestSavingError")
        }
        favoriteCities.append(city)
    }

    func fetchfavoritesCities() throws -> [CityModel] {
        if shouldThrowError {
            throw DomainError.fetchingError(message: "TestFetchingError")
        }
        return favoriteCities
    }

    func deleteFavoriteCity(_ city: CityModel) throws {
        if shouldThrowError {
            throw DomainError.deletingError(message: "TestDeletingError")
        }
        favoriteCities.removeAll { $0.id == city.id }
    }
}

