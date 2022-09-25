//
//  DetailsFactory.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.



final class DetailsFactory {

    func make(userName: String, repositoryName: String) -> DetailsViewController {
        let viewController = DetailsViewController.instantiate()
        viewController.router.dataStore.repositoryName = repositoryName
        viewController.router.dataStore.userName = userName
        
        return viewController
    }

}
