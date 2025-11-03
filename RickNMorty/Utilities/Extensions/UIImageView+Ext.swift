//
//  UIImageView+Ext.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

extension UIImageView {
    func fetchImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            
            guard error == nil else {
                Logger.shared.error("Error fetching image: \(error!)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                Logger.shared.error("Invalid image data")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    func setImage(named name: String) {
        self.image = UIImage(named: name)
    }
}
