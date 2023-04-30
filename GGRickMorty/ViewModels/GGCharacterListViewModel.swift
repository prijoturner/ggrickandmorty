//
//  GGCharacterListViewModel.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

final class GGCharacterListViewModel {
    
    // MARK: - Properties
    public var characters: [Character] = []
    public var searchedCharacters: [Character] = []
    public var filteredCharacters: [Character] = []
    public var selectedFilters: [String] = []
    public var isFiltersActive = false
    public var isSearchBarActive = false
    
    // MARK: - Public Methods
    public func fetchAllCharacters(page: Int? = nil, completion: @escaping (Result<[Character], Error>) -> Void) {
        GGService.shared.makeRequest(endpoint: .character, page: page) { (result: Result<GGAllCharacter, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchCharacters(limit: Int = 10, completion: @escaping (Result<[Character], Error>) -> Void) {
        var currentPage = 1
        
        /// Fetch characters for each page up to the limit
        func fetchNextPage() {
            if currentPage <= limit {
                fetchAllCharacters(page: currentPage) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let response):
                        /// Append the fetched characters to the local array
                        strongSelf.characters += response
                        
                        /// Check if we have reached the limit
                        if currentPage == limit {
                            /// Call completion handler with the fetched characters
                            completion(.success(response))
                        } else {
                            /// Fetch the next page of characters
                            currentPage += 1
                            fetchNextPage()
                        }
                        
                    case .failure(let error):
                        /// Call completion handler with the error
                        completion(.failure(error))
                    }
                }
            } else {
                /// Call completion handler with the fetched characters
                completion(.success(characters))
            }
        }
        
        /// Start fetching the first page of characters
        currentPage = 1
        fetchNextPage()
    }
    
    public func applyFilter(filters: [String]) {
        selectedFilters = filters
        filteredCharacters = characters.filter { (char) -> Bool in
            if filters.count == 0 {
                /// Return all characters if no filters are provided
                return true
            } else if filters.count == 1 {
                /// Filter using OR condition for single filter
                return char.status.rawValue == filters[0] ||
                char.species == filters[0] ||
                char.gender.rawValue == filters[0]
            } else {
                /// Filter using AND condition for multiple filters
                let matchingFilters = filters.filter { (filter) -> Bool in
                    return char.status.rawValue == filter ||
                    char.species == filter ||
                    char.gender.rawValue == filter
                }
                return matchingFilters.count == filters.count
            }
        }
        isFiltersActive = filteredCharacters.isEmpty ? false : true
    }
    
    public func resetFilters() {
        selectedFilters = []
        filteredCharacters = []
        isFiltersActive = false
    }
    
    public func searchForCharacters(with searchTerm: String) {
        searchedCharacters = characters.filter { (char) -> Bool in
            return char.name.lowercased().contains(searchTerm.lowercased())
        }
    }
    
    public func getNumberOfItems() -> Int {
        if isSearchBarActive {
            return searchedCharacters.count
        } else if isFiltersActive {
            return filteredCharacters.count
        } else {
            return characters.count
        }
    }
    
    public func getCharacter(at index: Int) -> Character {
        if isSearchBarActive {
            return searchedCharacters[index]
        } else if isFiltersActive {
            return filteredCharacters[index]
        } else {
            return characters[index]
        }
    }
    
    public func getSelectedFilters() -> [String] {
        return selectedFilters
    }
    
    public func setIsSearchBarActive(_ isActive: Bool) {
        isSearchBarActive = isActive
    }
    
}
