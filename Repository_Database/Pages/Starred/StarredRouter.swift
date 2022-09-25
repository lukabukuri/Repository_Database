//
//  StarredRouter.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.


import UIKit

enum StarredRoutingDestination {
    case details(repositoryName: String)
}

protocol StarredRoutingLogic {
    func navigate(to destination: StarredRoutingDestination)
}

protocol StarredDataPassing {
    var dataStore: StarredDataStore { get set }
}

final class StarredRouter {

    weak var viewController: StarredViewController?
    var dataStore: StarredDataStore

    init(viewController: StarredViewController,
         dataStore: StarredDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

}

// MARK: - StarredRoutingLogic implementation
extension StarredRouter: StarredRoutingLogic {

    func navigate(to destination: StarredRoutingDestination) {
        switch destination {
        case .details(let repositoryName):
            self.navigateToDetails(repositoryName: repositoryName)
        }
    }

    private func navigateToDetails(repositoryName: String) {
        let repository = dataStore.repositories.first { $0.repositoryName == repositoryName}
        let detailsViewController = DetailsFactory().make(repository: repository)
        self.viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
}

// MARK: - StarredDataPassing implementation
extension StarredRouter: StarredDataPassing {
}
