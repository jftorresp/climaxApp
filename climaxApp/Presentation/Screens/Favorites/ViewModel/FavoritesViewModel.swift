//
//  FavoritesViewModel.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import Foundation
import SwiftUI

class FavoritesViewModel: ObservableObject {
    private let favoritesUseCase: FavoritesUseCase
    @Published var favoriteCities: [City] = []
    @Published var errorMessage: String?
    @Published var deleteMode: Bool = false
    
    init(favoritesUseCase: FavoritesUseCase = FavoritesUseCaseImpl()) {
        self.favoritesUseCase = favoritesUseCase
    }
    
    func removeFromFavorites(_ city: City) {
        do {
            try favoritesUseCase.deleteFavoriteCity(city)
            loadFavoriteCities()
            withAnimation {
                self.deleteMode = false
            }
        } catch {
            self.errorMessage = "An error ocurred deleting that city, Try again later."
        }
    }

    func loadFavoriteCities() {
        do {
            favoriteCities = try favoritesUseCase.fetchfavoritesCities()
        } catch {
            self.errorMessage = "An error ocurred when trying to fetch favorites. Try again later."
        }
    }
}

extension FavoritesViewModel {
    var favoritesTitleLabel: String {
        return "Favorites"
    }
    
    var noFavoritesTitleLabel: String {
        return "No favorites :("
    }
    
    var noFavoritesSubTitleLabel: String {
        return "Favorite a city from the search to view it faster."
    }
    
    func latitudeLongitudeLabel(lat: Double, lon: Double) -> String {
        return "LAT: \(String(format: "%.1f", lat))°, LON: \(String(format: "%.1f", lon))°"
    }
    
}
