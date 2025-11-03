//
//  LocationDisplayData.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation

struct LocationDisplayData {
    let id: Int
    let name: String
    let type: String
    let dimension: String
}

struct LocationDetailDisplayData {
    let name: String
    let typeText: String
    let dimensionText: NSAttributedString
    let createdText: NSAttributedString
    let residentsTitle: String
}

extension LocationModel {
    
    func toDisplayData() -> LocationDisplayData {
        return LocationDisplayData(
            id: id,
            name: name,
            type: type,
            dimension: dimension
        )
    }
    
}
