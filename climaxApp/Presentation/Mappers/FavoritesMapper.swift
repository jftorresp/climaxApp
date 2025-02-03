//
//  FavoritesMapper.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import Foundation

class FavoritesMapper {
    static func mapFavoriteCityToDomain(_ city: City) -> CityModel {
        return CityModel(
            id: city.id,
            name: city.name,
            region: city.region,
            country: city.country,
            latitude: city.latitude,
            longitude: city.longitude,
            url: city.url
        )
    }
}
