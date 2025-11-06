//
//  CharacterRepository.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation
import Combine

/// Protocol defining the interface for character data operations.
protocol CharacterRepositoryProtocol {
    /// Fetches characters from the API.
    ///
    /// - Parameter page: Optional page number for pagination.
    /// - Returns: A publisher that emits an array of character models or an error.
    func fetchCharacters(page: Int?) -> AnyPublisher<[CharacterModel], Error>
}

/// Repository responsible for fetching character data from the Rick and Morty API.
///
/// `CharacterRepository` abstracts the data layer and uses Combine for reactive data flows.
final class CharacterRepository: CharacterRepositoryProtocol {
    
    private let service: Services
    
    /// Initializes a new character repository.
    ///
    /// - Parameter service: The networking service to use. Default is the shared instance.
    init(service: Services = .shared) {
        self.service = service
    }
    
    /// Fetches characters from the API for the specified page.
    ///
    /// - Parameter page: Optional page number for pagination. If `nil`, fetches the first page.
    /// - Returns: A publisher that emits an array of `CharacterModel` or an error.
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
