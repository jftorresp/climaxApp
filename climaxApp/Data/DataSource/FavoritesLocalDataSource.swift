//
//  FavoritesLocalDataSource.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import CoreData

protocol FavoritesLocalDataSource {
    func saveFavoriteCity(_ city: CityModel) throws
    func fetchfavoritesCities() throws -> [CityModel]
    func deleteFavoriteCity(_ city: CityModel) throws
}

class FavoritesLocalDataSourceImpl: FavoritesLocalDataSource {
    func saveFavoriteCity(_ city: CityModel) throws {
        let entity = CityEntity(context: CoreDataManager.shared.context)
        entity.id = Int64(city.id)
        entity.name = city.name
        entity.country = city.country
        entity.region = city.region
        entity.latitude = city.latitude
        entity.longitude = city.longitude
        entity.url = city.url
        
        do {
            try CoreDataManager.shared.saveContext()
        } catch {
            throw DataError.unkwownError(message: error.localizedDescription)
        }
    }
    
    func fetchfavoritesCities() throws -> [CityModel] {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        do {
            return try CoreDataManager.shared.context.fetch(request).map { CityModel(entity: $0) }
        } catch {
            print("Error while trying to load favorite citites: \(error)")
            throw DataError.unkwownError(message: error.localizedDescription)
            return []
        }
    }
    
    func deleteFavoriteCity(_ city: CityModel) throws {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", city.id)

        do {
            let results = try CoreDataManager.shared.context.fetch(request)
            for object in results {
                CoreDataManager.shared.deleteContext(object: object)
            }
            try CoreDataManager.shared.saveContext()
        } catch {
            print("Error deleting city: \(error)")
            throw DataError.unkwownError(message: error.localizedDescription)
        }
    }
}
