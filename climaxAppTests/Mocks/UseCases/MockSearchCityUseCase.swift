//
//  MockSearchCityUseCase.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import Foundation
@testable import climaxApp

class MockSearchCityUseCase: SearchCityUseCase {
    var shouldThrowError = false
    var shouldReturnEmpty = false

    func execute(_ name: String) async throws -> [City] {
        if shouldThrowError {
            throw DomainError.noLocationFound
        }
        return shouldReturnEmpty ? [] : [City.mockChicagoCity, City.mockNewYorkCity]
    }
}
