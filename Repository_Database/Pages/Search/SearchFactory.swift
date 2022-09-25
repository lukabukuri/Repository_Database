//
//  SearchFactory.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//


import Foundation

final class SearchFactory {

    func make() -> SearchViewController {
        let viewController = SearchViewController.instantiate()
        
        return viewController
    }

}
