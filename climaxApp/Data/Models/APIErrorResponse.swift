//
//  APIErrorResponse.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 31/01/25.
//

import Foundation

struct APIErrorResponse: Decodable {
    let error: APIError

    struct APIError: Decodable {
        let code: Int
        let message: String
    }
}
