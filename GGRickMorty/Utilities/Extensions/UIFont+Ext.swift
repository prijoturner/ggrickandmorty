//
//  UIFont+Ext.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

extension UIFont {
    enum SFProRoundedStyle {
        case regular, semibold, bold
    }

    static func SFProRounded(style: SFProRoundedStyle, size: CGFloat) -> UIFont {
        switch style {
        case .regular:
            return UIFont(name: "SFProRounded-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        case .semibold:
            return UIFont(name: "SFProRounded-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
        case .bold:
            return UIFont(name: "SFProRounded-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
        }
    }
}
