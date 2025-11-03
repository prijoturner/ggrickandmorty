//
//  TabBarViewController.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        let characterVC = CharacterViewController()
        let locationVC = LocationViewController()
        let episodeVC = EpisodeViewController()
        
        characterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav1.tabBarItem = UITabBarItem(title: "Character", image: UIImage(named: "ic_character"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Location", image: UIImage(named: "ic_location"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(named: "ic_episode"), tag: 3)
        
        setViewControllers([nav1, nav2, nav3], animated: true)
        self.delegate = self
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NotificationCenter.default.post(name: NSNotification.Name("TabBarItemTapped"), object: nil)
    }
}

