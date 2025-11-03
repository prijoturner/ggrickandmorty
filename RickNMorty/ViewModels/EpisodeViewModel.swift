//
//  EpisodeViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 01/05/23.
//

import Foundation
import Combine

final class EpisodeViewModel {
    
    // MARK: - Properties
    private let repository: EpisodeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var allEpisodes: [EpisodeModel] = []
    private var isNextPageAvailable = true
    
    // MARK: - Published Properties
    @Published private(set) var displayEpisodes: [EpisodeDisplayData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private var searchText = ""
    private var isSearchBarActive = false
    
    // MARK: - Initialization
    init(repository: EpisodeRepositoryProtocol = EpisodeRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func fetchEpisodes(limit: Int = 10) {
        isLoading = true
        errorMessage = nil
        isNextPageAvailable = true
        
        fetchPages(currentPage: 1, limit: limit)
    }
    
    // MARK: - Private Methods
    private func fetchPages(currentPage: Int, limit: Int) {
        guard currentPage <= limit && isNextPageAvailable else {
            isLoading = false
            updateDisplayEpisodes()
            return
        }
        
        repository.fetchEpisodes(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.allEpisodes += result.episodes
                self.isNextPageAvailable = result.hasNextPage
                
                if currentPage == limit || !result.hasNextPage {
                    self.isLoading = false
                    self.updateDisplayEpisodes()
                } else {
                    self.fetchPages(currentPage: currentPage + 1, limit: limit)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchForEpisodes(with searchTerm: String, isActive: Bool) {
        searchText = searchTerm
        isSearchBarActive = isActive
        updateDisplayEpisodes()
    }
    
    func numberOfItems() -> Int {
        return displayEpisodes.count
    }
    
    func episode(at index: Int) -> EpisodeDisplayData {
        return displayEpisodes[index]
    }
    
    func getOriginalEpisode(at index: Int) -> EpisodeModel {
        let displayData = displayEpisodes[index]
        return allEpisodes.first { $0.id == displayData.id }!
    }
    
    private func updateDisplayEpisodes() {
        var filtered = allEpisodes
        
        // Apply search
        if isSearchBarActive && !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        displayEpisodes = filtered.map { $0.toDisplayData() }
    }
    
}
