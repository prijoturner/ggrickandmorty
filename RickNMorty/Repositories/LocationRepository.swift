//
//  LocationRepository.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation
import Combine

protocol LocationRepositoryProtocol {
    func fetchLocations(page: Int?) -> AnyPublisher<(locations: [LocationModel], hasNextPage: Bool), Error>
}

final class LocationRepository: LocationRepositoryProtocol {
    
    private let service: Services
    
    init(service: Services = .shared) {
        self.service = service
    }
    
    func fetchLocations(page: Int? = nil) -> AnyPublisher<(locations: [LocationModel], hasNextPage: Bool), Error> {
        return Future<(locations: [LocationModel], hasNextPage: Bool), Error> { [weak self] promise in
            self?.service.makeRequest(endpoint: .location, page: page) { (result: Result<LocationResults, Error>) in
                switch result {
                case .success(let response):
                    let hasNextPage = !(response.info.next?.isEmpty ?? true)
                    promise(.success((locations: response.results, hasNextPage: hasNextPage)))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
