//
//  EpisodeRepository.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation
import Combine

/// Protocol defining the interface for episode data operations.
protocol EpisodeRepositoryProtocol {
    /// Fetches episodes from the API.
    ///
    /// - Parameter page: Optional page number for pagination.
    /// - Returns: A publisher that emits a tuple containing an array of episodes and a pagination flag.
    func fetchEpisodes(page: Int?) -> AnyPublisher<(episodes: [EpisodeModel], hasNextPage: Bool), Error>
}

/// Repository responsible for fetching episode data from the Rick and Morty API.
///
/// `EpisodeRepository` abstracts the data layer and uses Combine for reactive data flows.
final class EpisodeRepository: EpisodeRepositoryProtocol {
    
    private let service: Services
    
    /// Initializes a new episode repository.
    ///
    /// - Parameter service: The networking service to use. Default is the shared instance.
    init(service: Services = .shared) {
        self.service = service
    }
    
    /// Fetches episodes from the API for the specified page.
    ///
    /// - Parameter page: Optional page number for pagination. If `nil`, fetches the first page.
    /// - Returns: A publisher that emits a tuple containing episodes array and a boolean indicating if more pages exist.
    func fetchEpisodes(page: Int? = nil) -> AnyPublisher<(episodes: [EpisodeModel], hasNextPage: Bool), Error> {
        return Future<(episodes: [EpisodeModel], hasNextPage: Bool), Error> { [weak self] promise in
            self?.service.makeRequest(endpoint: .episode, page: page) { (result: Result<EpisodeResults, Error>) in
                switch result {
                case .success(let response):
                    let hasNextPage = !(response.info.next?.isEmpty ?? true)
                    promise(.success((episodes: response.results, hasNextPage: hasNextPage)))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
