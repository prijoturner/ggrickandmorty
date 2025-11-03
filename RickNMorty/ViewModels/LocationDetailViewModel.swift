//
//  LocationDetailViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 30/04/23.
//

import UIKit
import Combine

final class LocationDetailViewModel {
    
    // MARK: - Properties
    var location: LocationModel? {
        didSet {
            updateDisplayData()
        }
    }
    
    @Published var displayLocationDetail: LocationDetailDisplayData?
    
    // MARK: - Initialization
    init(location: LocationModel? = nil) {
        self.location = location
        updateDisplayData()
    }
    
    // MARK: - Public Methods
    func numberOfResidents() -> Int {
        return location?.residents.count ?? 0
    }
    
    func resident(at index: Int) -> String? {
        guard let location = location, index < location.residents.count else { return nil }
        return location.residents[index]
    }
    
    // MARK: - Private Methods
    private func updateDisplayData() {
        guard let location = location else {
            displayLocationDetail = nil
            return
        }
        
        let typeText = "Type: \(location.type)"
        let dimensionAttributedString = AttributedStringHelper.attributedStringForLineBreak(
            title: "Dimension:",
            subTitle: location.dimension
        )
        let createdAttributedString = location.created.attributedStringForCreatedText(isDetail: true)
        
        displayLocationDetail = LocationDetailDisplayData(
            name: location.name,
            typeText: typeText,
            dimensionText: dimensionAttributedString,
            createdText: createdAttributedString,
            residentsTitle: "Residents"
        )
    }
}
