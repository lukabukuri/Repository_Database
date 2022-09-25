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
        self.delegate = self
    }
    
    private func setupViewControllers() {
        let searchViewController = SearchFactory().make()
        searchViewController.tabBarItem = .init(title: Constants.searchTitle, image: .init(symbol: .magnifyingGlass), tag: 0)
        
        let starredViewController = StarredFactory().make()
        starredViewController.tabBarItem = .init(title: Constants.starredTitle, image: .init(symbol: .starFill), tag: 1)
        
        self.viewControllers = [
            CustomNavigationController(rootViewController: searchViewController),
            CustomNavigationController(rootViewController: starredViewController)
        ]
    }
    
}
// MARK: - UITabBarControllerDelegate Implementation
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController === tabBarController.selectedViewController {
            scrollToTop(view: viewController.view, navigationController: viewController as? CustomNavigationController)
        }
        
        return true
    }
}
