//
//  CharacterDisplayData.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation

struct CharacterDisplayData {
    let id: Int
    let name: String
    let species: String
    let imageURL: String
}

struct CharacterDetailDisplayData {
    let name: String
    let status: String
    let statusImageName: String
    let gender: String
    let genderImageName: String
    let species: String
    let createdText: NSAttributedString
    let origin: String
    let location: String
    let imageURL: String
    let episodeURLs: [String]
}

extension CharacterModel {
    
    func toDisplayData() -> CharacterDisplayData {
        return CharacterDisplayData(
            id: id,
            name: name,
            species: species,
            imageURL: image
        )
    }
    
    func toDetailDisplayData() -> CharacterDetailDisplayData {
        let statusImageName: String = {
            switch status {
            case .alive: return "ic_alive"
            case .dead: return "ic_dead"
            case .unknown: return "ic_unknown"
            }
        }()
        
        let genderImageName: String = {
            switch gender {
            case .male: return "ic_male"
            case .female: return "ic_female"
            case .genderless, .unknown: return "ic_unknown"
            }
        }()
        
        return CharacterDetailDisplayData(
            name: name,
            status: "Status: \(status.rawValue)",
            statusImageName: statusImageName,
            gender: "Gender: \(gender.rawValue)",
            genderImageName: genderImageName,
            species: "Species: \(species)",
            createdText: created.attributedStringForCreatedText(),
            origin: origin.name,
            location: location.name,
            imageURL: image,
            episodeURLs: episode
        )
    }
    
}
