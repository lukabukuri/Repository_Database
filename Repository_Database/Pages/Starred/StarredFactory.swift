//
//  StarredFactory.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.


import Foundation

final class StarredFactory {

    func make() -> StarredViewController {
        let viewController = StarredViewController.instantiate()
//        Set data if needed:
//        viewController.router.dataStore.propertyName = ...
        return viewController
    }

}
