//
//  MainTabBarController.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTabBar()
        self.setupViewControllers()
    }
    
    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .darkGray
        tabBar.backgroundColor = .darkGray
        self.tabBar.standardAppearance = appearance
        self.tabBar.tintColor = .white        
    }
    
    private func setupViewControllers() {
        let searchViewController = SearchFactory().make()
        searchViewController.tabBarItem = .init(title: Constants.searchTitle, image: .init(symbol: .magnifyingGlass), tag: 0)
        
        self.viewControllers = [
            CustomNavigationController(rootViewController: searchViewController)
        ]
    }
    
}
