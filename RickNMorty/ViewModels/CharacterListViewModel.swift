//
//  CharacterListViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation
import Combine

final class CharacterListViewModel {
    
    // MARK: - Properties
    private let repository: CharacterRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var allCharacters: [CharacterModel] = []
    
    // MARK: - Published Properties
    @Published private(set) var displayCharacters: [CharacterDisplayData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var selectedFilters: [String] = []
    
    private var searchText = ""
    private var isSearchBarActive = false
    
    // MARK: - Initialization
    init(repository: CharacterRepositoryProtocol = CharacterRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func fetchCharacters(limit: Int = 10) {
        isLoading = true
        errorMessage = nil
        
        let publishers = (1...limit).map { page in
            repository.fetchCharacters(page: page)
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] results in
                self?.allCharacters = results.flatMap { $0 }
                self?.updateDisplayCharacters()
            }
            .store(in: &cancellables)
    }
    
    func applyFilter(filters: [String]) {
        selectedFilters = filters
        updateDisplayCharacters()
    }
    
    func resetFilters() {
        selectedFilters = []
        updateDisplayCharacters()
    }
    
    func searchForCharacters(with searchTerm: String, isActive: Bool) {
        searchText = searchTerm
        isSearchBarActive = isActive
        updateDisplayCharacters()
    }
    
    func numberOfItems() -> Int {
        return displayCharacters.count
    }
    
    func character(at index: Int) -> CharacterDisplayData {
        return displayCharacters[index]
    }
    
    func getOriginalCharacter(at index: Int) -> CharacterModel {
        let displayData = displayCharacters[index]
        return allCharacters.first { $0.id == displayData.id }!
    }
    
    // MARK: - Private Methods
    private func updateDisplayCharacters() {
        var filtered = allCharacters
        
        // Apply search
        if isSearchBarActive && !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // Apply filters
        if !selectedFilters.isEmpty {
            filtered = filtered.filter { character in
                if selectedFilters.count == 1 {
                    return character.status.rawValue == selectedFilters[0] ||
                           character.species == selectedFilters[0] ||
                           character.gender.rawValue == selectedFilters[0]
                } else {
                    let matchingFilters = selectedFilters.filter { filter in
                        return character.status.rawValue == filter ||
                               character.species == filter ||
                               character.gender.rawValue == filter
                    }
                    return matchingFilters.count == selectedFilters.count
                }
            }
        }
        
        displayCharacters = filtered.map { $0.toDisplayData() }
    }
    
}
