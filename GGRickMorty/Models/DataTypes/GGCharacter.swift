//
//  GGCharacter.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let type: String
    let gender: CharacterGender
    let origin: CharacterOrigin
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    struct CharacterOrigin: Codable {
        let name: String
        let url: String
    }
    
    struct CharacterLocation: Codable {
        let name: String
        let url: String
    }
}

enum CharacterStatus: String, Codable {
    case dead = "Dead"
    case alive = "Alive"
    case unknown = "unknown"
}

enum CharacterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}
