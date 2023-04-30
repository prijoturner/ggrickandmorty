//
//  String+Ext.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

extension String {
    func formatDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "hh:mm MMMM yyyy"
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterSet.string(from: date)
        } else {
            return "Failed to format date"
        }
    }
    
    func attributedStringForCreatedText() -> NSMutableAttributedString {
        let createdText = "Created\n"
        let dateText = self.formatDate()
        let attributedText = NSMutableAttributedString(string: createdText)
        
        /// Set font for "Created" text
        attributedText.addAttribute(.font, value: UIFont.SFProRounded(style: .semibold, size: 14), range: NSRange(location: 0, length: createdText.count))
        
        /// Append date text and set font
        attributedText.append(NSAttributedString(string: dateText))
        attributedText.addAttribute(.font, value: UIFont.SFProRounded(style: .regular, size: 12), range: NSRange(location: attributedText.length - dateText.count, length: dateText.count))
        
        return attributedText
    }
}
