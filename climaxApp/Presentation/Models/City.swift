//
//  City.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation
import CoreData

struct City {
    let id: Int
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let url: String
    
    init(id: Int, name: String, region: String, country: String, latitude: Double, longitude: Double, url: String) {
        self.id = id
        self.name = name
        self.region = region
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.url = url
    }
    
    init(entity: CityEntity) {
        self.id = Int(entity.id)
        self.name = entity.name ?? "Unknown"
        self.region = entity.region ?? "Unknown"
        self.country = entity.country ?? "Unknown"
        self.latitude = entity.latitude
        self.longitude = entity.longitude
        self.url = entity.url ?? "Unknown"
    }
}
