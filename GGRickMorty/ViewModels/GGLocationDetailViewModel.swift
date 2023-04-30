//
//  GGLocationDetailViewModel.swift
//  GGRickMorty
//
//  Created by Kazuha on 30/04/23.
//

import UIKit

class GGLocationDetailViewModel {
    
    //MARK: - Properties
    var location: GGLocation? = nil
    
    //MARK: - Public functions
    func applyData(titleLabel: UILabel, headingLabel: UILabel, subHeadingLabel: UILabel, createdLabel: UILabel, titleForListLabel: UILabel) {
        guard let location = location else { return }
        titleLabel.text = location.name
        headingLabel.text = "Type: \(location.type)"
        subHeadingLabel.attributedText = AttributedStringHelper.attributedStringForLineBreak(title: "Dimension:", subTitle: location.dimension)
        createdLabel.attributedText = location.created.attributedStringForCreatedText()
        titleForListLabel.text = "Residents"
    }
}
