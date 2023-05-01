//
//  AttributedString+Helper.swift
//  GGRickMorty
//
//  Created by Kazuha on 30/04/23.
//

import UIKit

struct AttributedStringHelper {
    static func attributedStringForLineBreak(title: String, subTitle: String, titleFont: UIFont = .SFProRounded(style: .semibold, size: 16), subTitleFont: UIFont = .SFProRounded(style: .semibold, size: 16)) -> NSMutableAttributedString {
        let titleText = "\(title)\n"
        let subTitleText = subTitle
        let attributedText = NSMutableAttributedString(string: titleText)
        
        /// Set font for `title` text
        attributedText.addAttribute(.font, value: titleFont, range: NSRange(location: 0, length: titleText.count))
        
        /// Append `dateText` and set font for `subTitle`
        attributedText.append(NSAttributedString(string: subTitleText))
        attributedText.addAttribute(.font, value: subTitleFont, range: NSRange(location: attributedText.length - subTitleText.count, length: subTitleText.count))
        
        return attributedText
    }
}
