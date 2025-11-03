//
//  CharacterDetailViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import Foundation
import Combine

final class CharacterDetailViewModel {
    
    // MARK: - Published Properties
    @Published private(set) var displayCharacterDetail: CharacterDetailDisplayData?
    
    // MARK: - Initialization
    init(character: CharacterModel? = nil) {
        if let character = character {
            self.displayCharacterDetail = character.toDetailDisplayData()
        }
    }
    
    // MARK: - Public Methods
    func configure(with character: CharacterModel) {
        self.displayCharacterDetail = character.toDetailDisplayData()
    }
    
    func numberOfEpisodes() -> Int {
        return displayCharacterDetail?.episodeURLs.count ?? 0
    }
    
    func episodeURL(at index: Int) -> String? {
        return displayCharacterDetail?.episodeURLs[index]
    }
    
}
