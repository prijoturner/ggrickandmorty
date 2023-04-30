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
        dateFormatterSet.dateFormat = "hh:mm, MMMM yyyy"
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterSet.string(from: date)
        } else {
            return "Failed to format date"
        }
    }
    
    func attributedStringForCreatedText() -> NSMutableAttributedString {
        return AttributedStringHelper.attributedStringForLineBreak(title: "Created", subTitle: self.formatDate(), titleFont: UIFont.SFProRounded(style: .semibold, size: 14), subTitleFont: UIFont.SFProRounded(style: .regular, size: 12))
    }
}
