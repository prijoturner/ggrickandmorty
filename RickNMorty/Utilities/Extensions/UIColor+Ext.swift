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
    
    static var appLightGrey: UIColor {
        return UIColor(hexString: "#EDEDED") ?? .systemGray
    }
    
    static var appGrey: UIColor {
        return UIColor(hexString: "#BEBEBE") ?? .systemGray
    }
    
    static var appNeonGreen: UIColor {
        return UIColor(hexString: "#D3FF22") ?? .systemGreen
    }
    
    static var appPrimaryDark: UIColor {
        return UIColor(hexString: "#1E1F1D") ?? .black
    }
    
    static var appSecondaryDark: UIColor {
        return UIColor(hexString: "#373737") ?? .darkGray
    }
    
    static var appAccent: UIColor {
        return UIColor(hexString: "#DD49AB") ?? .systemPink
    }
    
    static var appLightBackground: UIColor {
        return UIColor(hexString: "#F0F0F0") ?? .lightGray
    }
}
