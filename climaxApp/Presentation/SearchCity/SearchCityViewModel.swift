//
//  SearchcITYviewModel.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 1/02/25.
//

import Foundation

class SearchCityViewModel: ObservableObject {
    private let searchCityUseCase: SearchCityUseCase
    @Published var searchText: String = ""
    @Published var noResultsFound: Bool = false
    @Published var cities: [City] = []
    @Published var errorMessage: String?
    
    init (searchCityUseCase: SearchCityUseCase = SearchCityUseCaseImpl()) {
        self.searchCityUseCase = searchCityUseCase
    }
    
    // MARK: Public functions
    
    @MainActor
    func searchCityByName(name: String) async throws {
        if searchText.isEmpty {
            resetSearch()
        } else {
            do {
                self.cities = try await searchCityUseCase.execute(name)
                if self.cities.isEmpty {
                    self.noResultsFound = true
                } else {
                    self.noResultsFound = false
                }
            } catch DomainError.noLocationFound {
                self.errorMessage = "No location found, please try another value."
            } catch {
                self.errorMessage = "An error ocurred while searching. Try again later."
            }
        }
    }
    
    // MARK: Private functions
    
    private func resetSearch() {
        self.cities = []
        self.noResultsFound = false
    }
}

extension SearchCityViewModel {
    var searchTitleLabel: String {
        return "Search"
    }
    
    var noSearchTitleLabel: String {
        return "Search!"
    }
    
    var noSearchSubTitleLabel: String {
        return "Type the name of a city to search for it's forecast."
    }
    
    var noResultsTitleLabel: String {
        return "No Results"
    }
    
    var noResultsSubTitleLabel: String {
        return "No cities found for \"\(searchText)\"."
    }
}
