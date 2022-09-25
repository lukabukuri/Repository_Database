//
//  MainTabBarController.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private var counterForAppLanguageOffer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTabBar()
        self.setupViewControllers()
    }
    
    // MARK: - Private Methods
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
    
    @objc private func changeLanguage() {
        let targetLanguage = Language.allCases.first { $0.rawValue != Locale.preferredLanguages.first }
        guard let language = targetLanguage?.rawValue else { return }
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        Bundle.setLanguage(language)
        self.tabBar.window?.rootViewController = MainTabBarController()
    }
    
}


// MARK: - UITabBarControllerDelegate Implementation
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController === tabBarController.selectedViewController {
            scrollToTop(view: viewController.view, navigationController: viewController as? CustomNavigationController)
            
            // MARK: - ⚠️ Press tab bar item 5 times to change the language
            counterForAppLanguageOffer += 1
            if counterForAppLanguageOffer % 5 == 0 {
                self.presentAlert(title: nil, message: Constants.askingForAppLanguageChange, actions: [
                    .no(handler: nil), .yes(handler: { [weak self] in
                        self?.changeLanguage()
                    })])
            }
        } else {
            counterForAppLanguageOffer = 0
        }
        return true
    }
}
