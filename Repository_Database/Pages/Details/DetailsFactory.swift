//
//  DetailsFactory.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.



final class DetailsFactory {

    func make(userName: String? = nil, repositoryName: String? = nil, repository: Repository? = nil) -> DetailsViewController {
        let viewController = DetailsViewController.instantiate()
        if let repository {
            viewController.router.dataStore.repository = repository
            viewController.router.dataStore.isRepositorySaved = true
        } else {
            viewController.router.dataStore.repositoryName = repositoryName
            viewController.router.dataStore.userName = userName
        }
    
        
        return viewController
    }

}
