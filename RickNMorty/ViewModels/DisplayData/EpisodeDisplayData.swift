//
//  EpisodeDisplayData.swift
//  RickNMorty
//
//  Created by Kazuha on 31/10/25.
//

import Foundation

struct EpisodeDisplayData {
    let id: Int
    let name: String
    let episode: String
    let airDate: String
    let season: String
}

struct EpisodeDetailDisplayData {
    let name: String
    let headingText: NSAttributedString
    let episodeText: NSAttributedString
    let createdText: NSAttributedString
    let charactersTitle: String
}

extension EpisodeModel {
    
    func toDisplayData() -> EpisodeDisplayData {
        let seasonEpisode = episode.components(separatedBy: "E")
        let season = seasonEpisode.first?.replacingOccurrences(of: "S", with: "") ?? ""
        
        return EpisodeDisplayData(
            id: id,
            name: name,
            episode: episode,
            airDate: airDate,
            season: season
        )
    }
    
    
}
