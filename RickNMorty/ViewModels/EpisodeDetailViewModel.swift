//
//  EpisodeDetailViewModel.swift
//  RickNMorty
//
//  Created by Kazuha on 01/05/23.
//

import UIKit
import Combine

final class EpisodeDetailViewModel {
    
    // MARK: - Properties
    var episode: EpisodeModel? {
        didSet {
            updateDisplayData()
        }
    }
    
    @Published var displayEpisodeDetail: EpisodeDetailDisplayData?
    
    // MARK: - Initialization
    init(episode: EpisodeModel? = nil) {
        self.episode = episode
        updateDisplayData()
    }
    
    // MARK: - Public Methods
    func numberOfCharacters() -> Int {
        return episode?.characters.count ?? 0
    }
    
    func character(at index: Int) -> String? {
        guard let episode = episode, index < episode.characters.count else { return nil }
        return episode.characters[index]
    }
    
    // MARK: - Private Methods
    private func updateDisplayData() {
        guard let episode = episode else {
            displayEpisodeDetail = nil
            return
        }
        
        let headingText = "Air Date: \(episode.airDate.formatDate())"
        let episodeText = episode.episode.formatEpisodeString().capitalized
        
        let headingAttributedString = createStyledHeadingText(headingText)
        let episodeAttributedString = episodeText.styleEpisode()
        let createdAttributedString = episode.created.attributedStringForCreatedText(isDetail: true)
        
        displayEpisodeDetail = EpisodeDetailDisplayData(
            name: episode.name,
            headingText: headingAttributedString,
            episodeText: episodeAttributedString,
            createdText: createdAttributedString,
            charactersTitle: "Characters"
        )
    }
    
    private func createStyledHeadingText(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 9, length: text.count - 9)
        let font = UIFont.SFProRounded(style: .regular, size: 20)
        let attributes = [NSAttributedString.Key.font: font]
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
}
