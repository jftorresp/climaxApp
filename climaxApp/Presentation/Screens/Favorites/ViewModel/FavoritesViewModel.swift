//
//  FavoritesViewModel.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteCities: [City] = []
}
