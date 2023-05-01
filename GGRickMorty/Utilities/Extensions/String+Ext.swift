//
//  String+Ext.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

extension String {
    func formatDate(isDetail: Bool = false) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateFormatterSet = DateFormatter()
        if let _ = dateFormatterGet.date(from: self) {
            /// Input date string is in the "yyyy-MM-dd'T'HH:mm:ss.SSSZ" format
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            dateFormatterSet.dateFormat = isDetail ? "hh:mm, dd MMMM yyyy" : "hh:mm, MMMM yyyy"
        } else {
            /// Input date string is in the "MMMM dd, yyyy" format
            dateFormatterGet.dateFormat = "MMMM dd, yyyy"
            dateFormatterSet.dateFormat = "dd MMMM yyyy"
        }
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterSet.string(from: date)
        } else {
            return "Failed to format date"
        }
    }
    
    
    func attributedStringForCreatedText(isDetail: Bool = false) -> NSMutableAttributedString {
        return AttributedStringHelper.attributedStringForLineBreak(title: "Created", subTitle: self.formatDate(isDetail: isDetail), titleFont: .SFProRounded(style: .semibold, size: 14), subTitleFont: .SFProRounded(style: .regular, size: 12))
    }
    
    func formatEpisodeString() -> String {
        let components = self.components(separatedBy: "E")
        guard components.count == 2, let season = Int(components[0].dropFirst()), let episode = Int(components[1]) else {
            return "Invalid episode string"
        }
        
        return "season: \(season)\nepisode: \(episode)"
    }
    
    func styleEpisode(font: UIFont = .SFProRounded(style: .regular, size: 16), boldFont: UIFont = .SFProRounded(style: .semibold, size: 16)) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let numberRegex = try! NSRegularExpression(pattern: "\\b\\d+\\b")
        let numberMatches = numberRegex.matches(in: self, range: NSRange(startIndex..., in: self))
        let regularAttributes = [NSAttributedString.Key.font: font]

        for match in numberMatches {
            attributedString.addAttributes(regularAttributes, range: match.range)
        }

        return attributedString
    }
    
}
