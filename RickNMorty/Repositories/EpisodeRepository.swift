//
//  EpisodeRepository.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation
import Combine

protocol EpisodeRepositoryProtocol {
    func fetchEpisodes(page: Int?) -> AnyPublisher<(episodes: [EpisodeModel], hasNextPage: Bool), Error>
}

final class EpisodeRepository: EpisodeRepositoryProtocol {
    
    private let service: Services
    
    init(service: Services = .shared) {
        self.service = service
    }
    
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
