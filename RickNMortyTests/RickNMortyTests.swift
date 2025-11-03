//
//  RickNMortyTests.swift
//  RickNMortyTests
//
//  Created by Kazuha on 29/04/23.
//

import XCTest
import Combine

// Note: Import the app target to access internal types
// The @testable attribute allows testing internal methods
@testable import RickNMorty

// MARK: - Model Tests
final class CharacterModelTests: XCTestCase {
    
    func testCharacterDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "Rick Sanchez",
            "status": "Alive",
            "species": "Human",
            "type": "",
            "gender": "Male",
            "origin": {
                "name": "Earth (C-137)",
                "url": "https://rickandmortyapi.com/api/location/1"
            },
            "location": {
                "name": "Citadel of Ricks",
                "url": "https://rickandmortyapi.com/api/location/3"
            },
            "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            "episode": [
                "https://rickandmortyapi.com/api/episode/1"
            ],
            "url": "https://rickandmortyapi.com/api/character/1",
            "created": "2017-11-04T18:48:46.250Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let character = try JSONDecoder().decode(CharacterModel.self, from: data)
        
        XCTAssertEqual(character.id, 1)
        XCTAssertEqual(character.name, "Rick Sanchez")
        XCTAssertEqual(character.status, .alive)
        XCTAssertEqual(character.species, "Human")
        XCTAssertEqual(character.gender, .male)
        XCTAssertEqual(character.origin.name, "Earth (C-137)")
        XCTAssertEqual(character.location.name, "Citadel of Ricks")
    }
    
    func testCharacterStatusEnum() {
        XCTAssertEqual(CharacterStatus.alive.rawValue, "Alive")
        XCTAssertEqual(CharacterStatus.dead.rawValue, "Dead")
        XCTAssertEqual(CharacterStatus.unknown.rawValue, "unknown")
    }
    
    func testCharacterGenderEnum() {
        XCTAssertEqual(CharacterGender.male.rawValue, "Male")
        XCTAssertEqual(CharacterGender.female.rawValue, "Female")
        XCTAssertEqual(CharacterGender.genderless.rawValue, "Genderless")
        XCTAssertEqual(CharacterGender.unknown.rawValue, "unknown")
    }
}

final class EpisodeModelTests: XCTestCase {
    
    func testEpisodeDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "Pilot",
            "air_date": "December 2, 2013",
            "episode": "S01E01",
            "characters": [
                "https://rickandmortyapi.com/api/character/1"
            ],
            "url": "https://rickandmortyapi.com/api/episode/1",
            "created": "2017-11-10T12:56:33.798Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let episode = try JSONDecoder().decode(EpisodeModel.self, from: data)
        
        XCTAssertEqual(episode.id, 1)
        XCTAssertEqual(episode.name, "Pilot")
        XCTAssertEqual(episode.airDate, "December 2, 2013")
        XCTAssertEqual(episode.episode, "S01E01")
        XCTAssertEqual(episode.characters.count, 1)
    }
}

final class LocationModelTests: XCTestCase {
    
    func testLocationDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "Earth (C-137)",
            "type": "Planet",
            "dimension": "Dimension C-137",
            "residents": [
                "https://rickandmortyapi.com/api/character/38"
            ],
            "url": "https://rickandmortyapi.com/api/location/1",
            "created": "2017-11-10T12:42:04.162Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let location = try JSONDecoder().decode(LocationModel.self, from: data)
        
        XCTAssertEqual(location.id, 1)
        XCTAssertEqual(location.name, "Earth (C-137)")
        XCTAssertEqual(location.type, "Planet")
        XCTAssertEqual(location.dimension, "Dimension C-137")
        XCTAssertEqual(location.residents.count, 1)
    }
}

// MARK: - Mock Repository
class MockCharacterRepository: CharacterRepositoryProtocol {
    var mockCharacters: [CharacterModel] = []
    var shouldFail = false
    var mockError: Error = NSError(domain: "TestError", code: -1, userInfo: nil)
    
    func fetchCharacters(page: Int?) -> AnyPublisher<[CharacterModel], Error> {
        if shouldFail {
            return Fail(error: mockError).eraseToAnyPublisher()
        }
        return Just(mockCharacters)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

// MARK: - ViewModel Tests
final class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    var mockRepository: MockCharacterRepository!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterRepository()
        viewModel = CharacterListViewModel(repository: mockRepository)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.displayCharacters.isEmpty)
        XCTAssertTrue(viewModel.selectedFilters.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testFetchCharactersSuccess() {
        let expectation = XCTestExpectation(description: "Fetch characters")
        
        // Setup mock data
        let mockCharacters = [
            createMockCharacter(id: 1, name: "Rick Sanchez"),
            createMockCharacter(id: 2, name: "Morty Smith"),
            createMockCharacter(id: 3, name: "Summer Smith")
        ]
        mockRepository.mockCharacters = mockCharacters
        
        // Observe displayCharacters
        viewModel.$displayCharacters
            .dropFirst() // Skip initial empty state
            .sink { displayCharacters in
                XCTAssertEqual(displayCharacters.count, 3)
                XCTAssertEqual(displayCharacters[0].name, "Rick Sanchez")
                XCTAssertFalse(self.viewModel.isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Fetch characters
        viewModel.fetchCharacters(limit: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testFetchCharactersFailure() {
        let expectation = XCTestExpectation(description: "Fetch characters failure")
        
        // Setup mock to fail
        mockRepository.shouldFail = true
        
        // Observe error
        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { errorMessage in
                XCTAssertFalse(errorMessage.isEmpty)
                XCTAssertFalse(self.viewModel.isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Fetch characters
        viewModel.fetchCharacters(limit: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchForCharacters() {
        // Setup mock data
        let mockCharacters = [
            createMockCharacter(id: 1, name: "Rick Sanchez"),
            createMockCharacter(id: 2, name: "Morty Smith"),
            createMockCharacter(id: 3, name: "Summer Smith")
        ]
        mockRepository.mockCharacters = mockCharacters
        
        let expectation = XCTestExpectation(description: "Search characters")
        
        // First fetch data
        viewModel.$displayCharacters
            .dropFirst()
            .sink { _ in
                // Then search
                self.viewModel.searchForCharacters(with: "Rick", isActive: true)
                XCTAssertEqual(self.viewModel.displayCharacters.count, 1)
                XCTAssertEqual(self.viewModel.displayCharacters.first?.name, "Rick Sanchez")
                
                // Test case insensitive search
                self.viewModel.searchForCharacters(with: "smith", isActive: true)
                XCTAssertEqual(self.viewModel.displayCharacters.count, 2)
                
                // Test no results
                self.viewModel.searchForCharacters(with: "NonExistent", isActive: true)
                XCTAssertTrue(self.viewModel.displayCharacters.isEmpty)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        viewModel.fetchCharacters(limit: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplyFilter() {
        let expectation = XCTestExpectation(description: "Apply filters")
        
        // Setup mock data
        let aliveCharacter = createMockCharacter(id: 1, name: "Rick", status: .alive, species: "Human", gender: .male)
        let deadCharacter = createMockCharacter(id: 2, name: "Morty", status: .dead, species: "Human", gender: .male)
        let femaleCharacter = createMockCharacter(id: 3, name: "Summer", status: .alive, species: "Human", gender: .female)
        mockRepository.mockCharacters = [aliveCharacter, deadCharacter, femaleCharacter]
        
        viewModel.$displayCharacters
            .dropFirst()
            .sink { _ in
                // Test single filter
                self.viewModel.applyFilter(filters: ["Alive"])
                XCTAssertEqual(self.viewModel.displayCharacters.count, 2)
                
                // Test multiple filters (AND condition)
                self.viewModel.applyFilter(filters: ["Alive", "Female"])
                XCTAssertEqual(self.viewModel.displayCharacters.count, 1)
                XCTAssertEqual(self.viewModel.displayCharacters.first?.name, "Summer")
                
                // Test no filters
                self.viewModel.applyFilter(filters: [])
                XCTAssertEqual(self.viewModel.displayCharacters.count, 3)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        viewModel.fetchCharacters(limit: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testResetFilters() {
        let expectation = XCTestExpectation(description: "Reset filters")
        
        mockRepository.mockCharacters = [createMockCharacter(id: 1, name: "Rick")]
        
        viewModel.$displayCharacters
            .dropFirst()
            .sink { _ in
                // Apply filter first
                self.viewModel.applyFilter(filters: ["Alive"])
                XCTAssertFalse(self.viewModel.selectedFilters.isEmpty)
                
                // Reset filters
                self.viewModel.resetFilters()
                XCTAssertTrue(self.viewModel.selectedFilters.isEmpty)
                XCTAssertEqual(self.viewModel.displayCharacters.count, 1)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        viewModel.fetchCharacters(limit: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testNumberOfItems() {
        let expectation = XCTestExpectation(description: "Number of items")
        
        let mockCharacters = [
            createMockCharacter(id: 1, name: "Rick"),
            createMockCharacter(id: 2, name: "Morty"),
            createMockCharacter(id: 3, name: "Summer")
        ]
        mockRepository.mockCharacters = mockCharacters
        
        viewModel.$displayCharacters
            .dropFirst()
            .sink { _ in
                // Test normal state
                XCTAssertEqual(self.viewModel.numberOfItems(), 3)
                
                // Test search active state
                self.viewModel.searchForCharacters(with: "Rick", isActive: true)
                XCTAssertEqual(self.viewModel.numberOfItems(), 1)
                
                // Test filter active state
                self.viewModel.searchForCharacters(with: "", isActive: false)
                self.viewModel.applyFilter(filters: ["Alive"])
                XCTAssertEqual(self.viewModel.numberOfItems(), 3)
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        viewModel.fetchCharacters(limit: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testGetCharacterDisplayData() {
        let expectation = XCTestExpectation(description: "Get character display data")
        
        let mockCharacters = [
            createMockCharacter(id: 1, name: "Rick"),
            createMockCharacter(id: 2, name: "Morty"),
            createMockCharacter(id: 3, name: "Summer")
        ]
        mockRepository.mockCharacters = mockCharacters
        
        viewModel.$displayCharacters
            .dropFirst()
            .sink { _ in
                // Test getting DisplayData from normal list
                let displayData = self.viewModel.character(at: 0)
                XCTAssertEqual(displayData.name, "Rick")
                XCTAssertEqual(displayData.id, 1)
                
                // Test getting from search results
                self.viewModel.searchForCharacters(with: "Morty", isActive: true)
                let searchResult = self.viewModel.character(at: 0)
                XCTAssertEqual(searchResult.name, "Morty")
                
                expectation.fulfill()
            }
            .store(in: &self.cancellables)
        
        viewModel.fetchCharacters(limit: 1)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testCharacterToDisplayDataTransformation() {
        let character = createMockCharacter(id: 1, name: "Rick Sanchez", species: "Human")
        let displayData = character.toDisplayData()
        
        XCTAssertEqual(displayData.id, 1)
        XCTAssertEqual(displayData.name, "Rick Sanchez")
        XCTAssertEqual(displayData.species, "Human")
        XCTAssertFalse(displayData.imageURL.isEmpty)
    }
    
    // MARK: - Helper Methods
    private func createMockCharacter(
        id: Int,
        name: String,
        status: CharacterStatus = .alive,
        species: String = "Human",
        gender: CharacterGender = .male
    ) -> CharacterModel {
        return CharacterModel(
            id: id,
            name: name,
            status: status,
            species: species,
            type: "",
            gender: gender,
            origin: CharacterModel.CharacterOrigin(name: "Earth", url: ""),
            location: CharacterModel.CharacterLocation(name: "Earth", url: ""),
            image: "",
            episode: [],
            url: "",
            created: ""
        )
    }
}

// MARK: - API Tests
final class EndpointTests: XCTestCase {
    
    func testEndpointPaths() {
        XCTAssertEqual(Endpoint.character.path, "/character")
        XCTAssertEqual(Endpoint.location.path, "/location")
        XCTAssertEqual(Endpoint.episode.path, "/episode")
    }
}

final class ServiceTests: XCTestCase {
    
    func testServiceSingleton() {
        let instance1 = Services.shared
        let instance2 = Services.shared
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testHTTPMethodRawValues() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
    }
    
    func testBaseURL() {
        XCTAssertEqual(Services.Constants.baseURL, "https://rickandmortyapi.com/api")
    }
}
