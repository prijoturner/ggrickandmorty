//
//  EpisodeModel.swift
//  RickNMorty
//
//  Created by Kazuha on 01/05/23.
//

import Foundation

struct EpisodeModel: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}
