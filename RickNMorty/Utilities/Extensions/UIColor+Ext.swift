//
//  UIColor+Ext.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.count != 6 {
            return nil
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    static var AppBlue: UIColor {
        return UIColor(hexString: "#007AFF") ?? .systemBlue
    }
    static var AppLightGrey: UIColor {
        return UIColor(hexString: "#EDEDED") ?? .systemGray
    }
    static var AppGrey: UIColor {
        return UIColor(hexString: "#BEBEBE") ?? .systemGray
    }
    static var AppNeonGreen: UIColor {
        return UIColor(hexString: "#D3FF22") ?? .systemGreen
    }
}
