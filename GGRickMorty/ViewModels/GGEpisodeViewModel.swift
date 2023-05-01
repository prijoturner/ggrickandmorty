//
//  GGEpisodeViewModel.swift
//  GGRickMorty
//
//  Created by Kazuha on 01/05/23.
//

import Foundation

final class GGEpisodeViewModel {
    
    // MARK: - Properties
    public var episodes: [GGEpisode] = []
    public var searchedEpisodes: [GGEpisode] = []
    public var isSearchBarActive = false
    private var isNextPageAvailable = true
    
    // MARK: - Public Methods
    public func fetchAllEpisodes(page: Int? = nil, completion: @escaping (Result<[GGEpisode], Error>) -> Void) {
        GGService.shared.makeRequest(endpoint: .episode, page: page) { (result: Result<GGEpisodeResults, Error>) in
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
    
    public func fetchEpisodes(limit: Int = 10, completion: @escaping (Result<[GGEpisode], Error>) -> Void) {
        var currentPage = 1
        
        /// Fetch episodes for each page up to the limit
        func fetchNextPage() {
            if currentPage <= limit && isNextPageAvailable {
                fetchAllEpisodes(page: currentPage) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let response):
                        /// Append the fetched episodes to the local array
                        strongSelf.episodes += response
                        
                        /// Check if we have reached the limit
                        if currentPage == limit {
                            /// Call completion handler with the fetched episodes
                            completion(.success(response))
                        } else {
                            /// Fetch the next page of episodes
                            currentPage += 1
                            fetchNextPage()
                        }
                        
                    case .failure(let error):
                        /// Call completion handler with the error
                        completion(.failure(error))
                    }
                }
            } else {
                /// Call completion handler with the fetched episodes
                completion(.success(episodes))
            }
        }
        
        /// Start fetching the first page of episodes
        currentPage = 1
        fetchNextPage()
    }
    
    public func searchForEpisodes(with searchTerm: String) {
        searchedEpisodes = episodes.filter { (char) -> Bool in
            return char.name.lowercased().contains(searchTerm.lowercased())
        }
    }
    
    public func getNumberOfItems() -> Int {
        if isSearchBarActive {
            return searchedEpisodes.count
        } else {
            return episodes.count
        }
    }
    
    public func getEpisode(at index: Int) -> GGEpisode {
        if isSearchBarActive {
            return searchedEpisodes[index]
        } else {
            return episodes[index]
        }
    }
    
    public func setIsSearchBarActive(_ isActive: Bool) {
        isSearchBarActive = isActive
    }
}
