//
//  MockCity.swift
//  climaxAppTests
//
//  Created by Juan Felipe Torres on 3/02/25.
//

import Foundation
@testable import climaxApp

extension City {
    static let mockCity: City = .init(
        id: 2566581,
        name: "Chicago",
        region: "Illinois",
        country: "United States of America",
        latitude: 41.85,
        longitude: -87.65,
        url: "chicago-illinois-united-states-of-america"
    )
}
