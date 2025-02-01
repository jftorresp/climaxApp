//
//  WeatherRepository.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

protocol WeatherRepository {
    func getForecastByCity(_ city: String) async throws -> ForecastModel
    func searchCity(_ query: String) async throws -> [CityModel]
}

class WeatherRepositoryImpl: WeatherRepository {
    let dataSource: WeatherRemoteDataSource
    
    init(dataSource: WeatherRemoteDataSource = WeatherRemoteDataSourceImpl()) {
        self.dataSource = dataSource
    }
    
    func getForecastByCity(_ city: String) async throws -> ForecastModel {
        do {
            let response = try await dataSource.getForecastByCity(city)
            return WeatherDataMapper.mapForecastToDomain(response)
        } catch DataError.apiError(let code, let message) {
            if code == 1003 {
                throw DomainError.parameterNotProvided
            } else if code == 1006 {
                throw DomainError.noLocationFound
            } else if code == 2006 {
                throw DomainError.invalidAPIKey
            } else if code == 2007 {
                throw DomainError.disabledAPIKey
            } else {
                throw DomainError.serverError(message: message)
            }
        } catch {
            throw DomainError.unexpectedError(message: error.localizedDescription)
        }
    }
    
    func searchCity(_ query: String) async throws -> [CityModel] {
        do {
            let response = try await dataSource.searchCity(query)
            let cities = response.map { cityResponse in
                WeatherDataMapper.mapCityToDomain(cityResponse)
            }
            return cities
        } catch DataError.apiError(let code, let message) {
            if code == 1003 {
                throw DomainError.parameterNotProvided
            } else if code == 1006 {
                throw DomainError.noLocationFound
            } else if code == 2006 {
                throw DomainError.invalidAPIKey
            } else if code == 2007 {
                throw DomainError.disabledAPIKey
            } else {
                throw DomainError.serverError(message: message)
            }
        } catch {
            throw DomainError.unexpectedError(message: error.localizedDescription)
        }
    }
}
