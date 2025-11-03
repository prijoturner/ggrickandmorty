//
//  LocationModel.swift
//  RickNMorty
//
//  Created by Kazuha on 30/04/23.
//

import Foundation

struct LocationModel: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name, type, dimension, residents, url, created
    }
}
