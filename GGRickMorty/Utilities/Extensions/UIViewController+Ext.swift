//
//  UIViewController+Ext.swift
//  GGRickMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

extension UIViewController {
    func hasNotch() -> Bool {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let mainWindow = windowScene.windows.first {
            if mainWindow.safeAreaInsets.top > 0 {
                if UIDevice.current.model.contains("iPhone") {
                    switch UIScreen.main.nativeBounds.height {
                    case 1792, 2340, 2436, 2532, 2556, 2688, 2778:
                        return true
                    default:
                        /// Other iPhone models
                        return false
                    }
                }
            } else {
                /// Devices without a notch
                return false
            }
        }
        /// Default value
        return false
    }
    
    func scrollToTop<T: UIScrollView>(of scrollView: T) {
        let topOffset = CGPoint(x: 0, y: -scrollView.adjustedContentInset.top)
        scrollView.setContentOffset(topOffset, animated: true)
    }

}
