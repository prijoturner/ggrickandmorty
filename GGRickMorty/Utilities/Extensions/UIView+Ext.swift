//
//  UIView+Ext.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
