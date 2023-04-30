//
//  GGLocationViewModel.swift
//  GGRickMorty
//
//  Created by Kazuha on 30/04/23.
//

import Foundation

final class GGLocationViewModel {
    
    // MARK: - Properties
    public var locations: [GGLocation] = []
    public var searchedLocations: [GGLocation] = []
    public var isSearchBarActive = false
    private var isNextPageAvailable = true
    
    // MARK: - Public Methods
    public func fetchAllLocations(page: Int? = nil, completion: @escaping (Result<[GGLocation], Error>) -> Void) {
        GGService.shared.makeRequest(endpoint: .location, page: page) { (result: Result<GGLocationResults, Error>) in
            switch result {
            case .success(let response):
                /// Set the `isNextPageAvailable` flag based on the response
                self.isNextPageAvailable = !(response.info.next?.isEmpty ?? true)
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchLocations(limit: Int = 10, completion: @escaping (Result<[GGLocation], Error>) -> Void) {
        var currentPage = 1
        
        /// Fetch locations for each page up to the limit
        func fetchNextPage() {
            if currentPage <= limit && isNextPageAvailable {
                fetchAllLocations(page: currentPage) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let response):
                        /// Append the fetched locations to the local array
                        strongSelf.locations += response
                        
                        /// Check if we have reached the limit
                        if currentPage == limit {
                            /// Call completion handler with the fetched locations
                            completion(.success(response))
                        } else {
                            /// Fetch the next page of locations
                            currentPage += 1
                            fetchNextPage()
                        }
                        
                    case .failure(let error):
                        /// Call completion handler with the error
                        completion(.failure(error))
                    }
                }
            } else {
                /// Call completion handler with the fetched locations
                completion(.success(locations))
            }
        }
        
        /// Start fetching the first page of locations
        currentPage = 1
        fetchNextPage()
    }
    
    public func searchForLocations(with searchTerm: String) {
        searchedLocations = locations.filter { (char) -> Bool in
            return char.name.lowercased().contains(searchTerm.lowercased())
        }
    }
    
    public func getNumberOfItems() -> Int {
        if isSearchBarActive {
            return searchedLocations.count
        } else {
            return locations.count
        }
    }
    
    public func getCharacter(at index: Int) -> GGLocation {
        if isSearchBarActive {
            return searchedLocations[index]
        } else {
            return locations[index]
        }
    }
    
    public func setIsSearchBarActive(_ isActive: Bool) {
        isSearchBarActive = isActive
    }
}
