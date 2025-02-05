//
//  MockFavoritesUseCase.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import Foundation
@testable import climaxApp

class MockFavoritesUseCase: FavoritesUseCase {
    var savedCities: [City] = []
    var shouldThrowError = false

    func saveFavoriteCity(_ city: City) throws {
        if shouldThrowError { throw DomainError.savingError(message: "SavingTestError") }
        savedCities.append(city)
    }

    func deleteFavoriteCity(_ city: City) throws {
        if shouldThrowError { throw DomainError.deletingError(message: "DeletingTestError")  }
        savedCities.removeAll { $0.id == city.id }
    }

    func fetchfavoritesCities() throws -> [City] {
        if shouldThrowError { throw DomainError.fetchingError(message: "FetchingTestError") }
        return savedCities
    }
}
