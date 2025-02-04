//
//  MockCity.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import Foundation
@testable import climaxApp

extension City {
    static let mockChicagoCity: City = .init(
        id: 2566581,
        name: "Chicago",
        region: "Illinois",
        country: "United States of America",
        latitude: 41.85,
        longitude: -87.65,
        url: "chicago-illinois-united-states-of-america"
    )
    
    static let mockNewYorkCity: City = .init(
        id: 2618724,
        name: "New York",
        region: "New York",
        country: "United States of America",
        latitude: 40.71,
        longitude: -74.01,
        url: "new-york-new-york-united-states-of-america"
    )
}
