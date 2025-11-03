//
//  CharacterRepository.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation
import Combine

protocol CharacterRepositoryProtocol {
    func fetchCharacters(page: Int?) -> AnyPublisher<[CharacterModel], Error>
}

final class CharacterRepository: CharacterRepositoryProtocol {
    
    private let service: Services
    
    init(service: Services = .shared) {
        self.service = service
    }
    
    func fetchCharacters(page: Int? = nil) -> AnyPublisher<[CharacterModel], Error> {
        return Future<[CharacterModel], Error> { [weak self] promise in
            self?.service.makeRequest(endpoint: .character, page: page) { (result: Result<CharacterResults, Error>) in
                switch result {
                case .success(let response):
                    promise(.success(response.results))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
