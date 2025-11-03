//
//  CharacterResults.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation

struct CharacterResults: Codable {
    let info: Info
    let results: [CharacterModel]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
