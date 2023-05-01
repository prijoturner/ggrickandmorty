//
//  GGEpisodeDetailViewModel.swift
//  GGRickMorty
//
//  Created by Kazuha on 01/05/23.
//

import UIKit

class GGEpisodeDetailViewModel {
    
    // MARK: - Properties
    var episode: GGEpisode? = nil
    
    // MARK: - Public Methods
    func applyData(titleLabel: UILabel, headingLabel: UILabel, subHeadingLabel: UILabel, createdLabel: UILabel, titleForListLabel: UILabel) {
        guard let episode = episode else { return }
        let headingText = "Air Date: \(episode.airDate.formatDate())"
        let episodeText = episode.episode.formatEpisodeString().capitalized
        titleLabel.text = episode.name
        subHeadingLabel.attributedText = episodeText.styleEpisode()
        createdLabel.attributedText = episode.created.attributedStringForCreatedText(isDetail: true)
        titleForListLabel.text = "Characters"
        changeStyle(for: headingLabel, text: headingText)
    }
    
    func changeStyle(for headingLabel: UILabel, text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let range = NSRange(location: 9, length: text.count - 9)
        let font = UIFont.SFProRounded(style: .regular, size: 20)
        let attributes = [NSAttributedString.Key.font: font]
        attributedString.addAttributes(attributes, range: range)
        headingLabel.attributedText = attributedString
    }
}
