//
//  AppDelegate.swift
//  RickNMorty
//
//  Created by Kazuha on 29/04/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setNavigationTitleStyle()
        setTabbarTitleStyle()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func setNavigationTitleStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.SFProRounded(style: .semibold, size: 20),
            .foregroundColor: UIColor.label
        ]
        appearance.largeTitleTextAttributes = [
            .font: UIFont.SFProRounded(style: .bold, size: 34),
            .foregroundColor: UIColor.label
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    private func setTabbarTitleStyle() {
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithDefaultBackground()
        
        // Normal state (unselected)
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.SFProRounded(style: .regular, size: 10),
            .foregroundColor: UIColor.systemGray
        ]
        
        // Selected state
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.SFProRounded(style: .semibold, size: 10),
            .foregroundColor: UIColor.systemBlue
        ]
        
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabAppearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
        tabAppearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabAppearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
        tabAppearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
        
        UITabBar.appearance().isTranslucent = true
    }
}

