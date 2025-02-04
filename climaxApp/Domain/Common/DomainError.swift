//
//  DomainError.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

enum DomainError: Error, Equatable {
    ///  Error code 1003: Parameter 'q' not provided.
    case parameterNotProvided
    ///  Error code 1006: No location found matching parameter 'q'
    case noLocationFound
    ///  Error code 2006: API key provided is invalid
    case invalidAPIKey
    ///  Error code 2007: API key has been disabled.
    case disabledAPIKey
    case serverError(message: String)
    case unexpectedError(message: String)
    
    case savingError(message: String)
    case fetchingError(message: String)
    case deletingError(message: String)
}
