//
//  LocationViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 30/04/23.
//

import Foundation
import Combine

final class LocationViewModel {
    
    // MARK: - Properties
    private let repository: LocationRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private var allLocations: [LocationModel] = []
    private var isNextPageAvailable = true
    
    // MARK: - Published Properties
    @Published private(set) var displayLocations: [LocationDisplayData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private var searchText = ""
    private var isSearchBarActive = false
    
    // MARK: - Initialization
    init(repository: LocationRepositoryProtocol = LocationRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func fetchLocations(limit: Int = 10) {
        isLoading = true
        errorMessage = nil
        isNextPageAvailable = true
        
        fetchPages(currentPage: 1, limit: limit)
    }
    
    // MARK: - Private Methods
    private func fetchPages(currentPage: Int, limit: Int) {
        guard currentPage <= limit && isNextPageAvailable else {
            isLoading = false
            updateDisplayLocations()
            return
        }
        
        repository.fetchLocations(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.allLocations += result.locations
                self.isNextPageAvailable = result.hasNextPage
                
                if currentPage == limit || !result.hasNextPage {
                    self.isLoading = false
                    self.updateDisplayLocations()
                } else {
                    self.fetchPages(currentPage: currentPage + 1, limit: limit)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchForLocations(with searchTerm: String, isActive: Bool) {
        searchText = searchTerm
        isSearchBarActive = isActive
        updateDisplayLocations()
    }
    
    func numberOfItems() -> Int {
        return displayLocations.count
    }
    
    func location(at index: Int) -> LocationDisplayData {
        return displayLocations[index]
    }
    
    func getOriginalLocation(at index: Int) -> LocationModel {
        let displayData = displayLocations[index]
        return allLocations.first { $0.id == displayData.id }!
    }
    
    private func updateDisplayLocations() {
        var filtered = allLocations
        
        // Apply search
        if isSearchBarActive && !searchText.isEmpty {
            filtered = filtered.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        displayLocations = filtered.map { $0.toDisplayData() }
    }
    
}
