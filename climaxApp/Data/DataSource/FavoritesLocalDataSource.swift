//
//  FavoritesLocalDataSource.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import CoreData

/// Defines the contract for managing favorite cities in local storage.
protocol FavoritesLocalDataSource {

    /// Saves a city to the local favorites storage.
    ///
    /// - Parameter city: The `CityModel` representing the city to be saved.
    /// - Throws: An error if the save operation fails.
    func saveFavoriteCity(_ city: CityModel) throws

    /// Retrieves the list of favorite cities from local storage.
    ///
    /// - Returns: An array of `CityModel` representing the saved favorite cities.
    /// - Throws: An error if the fetch operation fails.
    func fetchfavoritesCities() throws -> [CityModel]

    /// Deletes a city from the local favorites storage.
    ///
    /// - Parameter city: The `CityModel` representing the city to be removed.
    /// - Throws: An error if the delete operation fails.
    func deleteFavoriteCity(_ city: CityModel) throws
}

/// A Core Data implementation of `FavoritesLocalDataSource` for managing favorite cities.
///
/// This class provides methods to save, fetch, and delete favorite cities using Core Data.
///
/// - Uses `CoreDataManager.shared` to interact with Core Data.
/// - Converts `CityModel` to `CityEntity` for storage.
/// - Handles errors gracefully and throws `DataError.unkwownError` if operations fail.
class FavoritesLocalDataSourceImpl: FavoritesLocalDataSource {
    
    /// Saves a city to the local favorites storage using Core Data.
    ///
    /// - Parameter city: The `CityModel` representing the city to be saved.
    /// - Throws: `DataError.unkwownError` if the save operation fails.
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

    /// Retrieves the list of favorite cities stored in Core Data.
    ///
    /// - Returns: An array of `CityModel` representing the saved favorite cities.
    /// - Throws: `DataError.unkwownError` if the fetch operation fails.
    func fetchfavoritesCities() throws -> [CityModel] {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        do {
            return try CoreDataManager.shared.context.fetch(request).map { CityModel(entity: $0) }
        } catch {
            print("Error while trying to load favorite cities: \(error)")
            throw DataError.unkwownError(message: error.localizedDescription)
        }
    }

    /// Deletes a city from the local favorites storage in Core Data.
    ///
    /// - Parameter city: The `CityModel` representing the city to be removed.
    /// - Throws: `DataError.unkwownError` if the delete operation fails.
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
