//
//  FavoriteViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 04/11/25.
//

import Foundation
import Combine

final class FavoriteViewModel {
    
    // MARK: - Properties
    private let favoriteRepository: FavoriteRepository
    private var allFavorites: [FavoriteCharacter] = []
    
    // MARK: - Published Properties
    @Published private(set) var displayCharacters: [CharacterDetailDisplayData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var selectedFilters: [String] = []
    @Published private(set) var isEditMode = false
    @Published private(set) var selectedIndices: Set<Int> = []
    
    private var searchText = ""
    private var isSearchBarActive = false
    
    // MARK: - Initialization
    init(favoriteRepository: FavoriteRepository = FavoriteRepository()) {
        self.favoriteRepository = favoriteRepository
    }
    
    // MARK: - Public Methods
    func fetchFavoriteCharacters() {
        isLoading = true
        errorMessage = nil
        
        allFavorites = favoriteRepository.getFavoriteCharacters()
        updateDisplayCharacters()
        
        isLoading = false
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
    
    func removeFavorite(byName name: String) -> Bool {
        let success = favoriteRepository.removeFavorite(byName: name)
        if success {
            displayCharacters.removeAll { $0.name == name }
        }
        return success
    }
    
    func numberOfItems() -> Int {
        return displayCharacters.count
    }
    
    func character(at index: Int) -> CharacterDetailDisplayData? {
        guard index >= 0, index < displayCharacters.count else { return nil }
        return displayCharacters[index]
    }
    
    func getOriginalCharacter(at index: Int) -> CharacterModel {
        let displayData = displayCharacters[index]
        guard let favorite = allFavorites.first(where: { ($0.name ?? "") == displayData.name }) else {
            return CharacterModel(
                id: 0,
                name: "",
                status: .unknown,
                species: "",
                type: "",
                gender: .unknown,
                origin: CharacterModel.CharacterOrigin(name: "", url: ""),
                location: CharacterModel.CharacterLocation(name: "", url: ""),
                image: "",
                episode: [],
                url: "",
                created: ""
            )
        }
        
        let statusValue = favorite.status ?? "unknown"
        let status = CharacterStatus(rawValue: statusValue) ?? .unknown
        let genderValue = favorite.gender ?? "unknown"
        let gender = CharacterGender(rawValue: genderValue) ?? .unknown
        
        return CharacterModel(
            id: 0,
            name: favorite.name ?? "",
            status: status,
            species: favorite.species ?? "",
            type: "",
            gender: gender,
            origin: CharacterModel.CharacterOrigin(name: favorite.origin ?? "", url: ""),
            location: CharacterModel.CharacterLocation(name: favorite.location ?? "", url: ""),
            image: favorite.imageURL ?? "",
            episode: (favorite.episodes as? [String]) ?? [],
            url: "",
            created: favorite.created ?? ""
        )
    }
    
    // MARK: - Edit Mode Management
    func toggleEditMode() {
        isEditMode.toggle()
        if !isEditMode {
            selectedIndices.removeAll()
        }
    }
    
    func exitEditMode() {
        isEditMode = false
        selectedIndices.removeAll()
    }
    
    func toggleSelection(at index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.remove(index)
        } else {
            selectedIndices.insert(index)
        }
    }
    
    func isSelected(at index: Int) -> Bool {
        return selectedIndices.contains(index)
    }
    
    func hasSelectedItems() -> Bool {
        return !selectedIndices.isEmpty
    }
    
    func selectedItemsCount() -> Int {
        return selectedIndices.count
    }
    
    func removeSelectedFavorites() {
        let sortedIndices = selectedIndices.sorted(by: >)
        
        for index in sortedIndices {
            if let character = character(at: index) {
                _ = removeFavorite(byName: character.name)
            }
        }
        
        selectedIndices.removeAll()
        fetchFavoriteCharacters()
    }
    
    private func updateDisplayCharacters() {
        var filtered = allFavorites
        
        // Apply search
        if isSearchBarActive && !searchText.isEmpty {
            filtered = filtered.filter { ($0.name ?? "").lowercased().contains(searchText.lowercased()) }
        }
        
        // Apply filters
        if !selectedFilters.isEmpty {
            filtered = filtered.filter { character in
                if selectedFilters.count == 1 {
                    return character.status == selectedFilters[0] ||
                           character.species == selectedFilters[0] ||
                           character.gender == selectedFilters[0]
                } else {
                    let matchingFilters = selectedFilters.filter { filter in
                        return character.status == filter ||
                               character.species == filter ||
                               character.gender == filter
                    }
                    return matchingFilters.count == selectedFilters.count
                }
            }
        }
        
        displayCharacters = filtered.map { favorite in
            CharacterDetailDisplayData(
                name: favorite.name ?? "",
                status: "",
                statusImageName: "",
                gender: "",
                genderImageName: "",
                species: favorite.species ?? "",
                createdText: NSMutableAttributedString(string: ""),
                origin: favorite.origin ?? "",
                location: "",
                imageURL: favorite.imageURL ?? "",
                episodeURLs: [])
        }
    }
}

