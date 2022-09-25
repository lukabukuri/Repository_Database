//
//  SearchRouter.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//


enum SearchRoutingDestination {
    case details(repositoryName: String, userName: String)
}

protocol SearchRoutingLogic {
    func navigate(to destination: SearchRoutingDestination)
}

protocol SearchDataPassing {
    var dataStore: SearchDataStore { get set }
}

final class SearchRouter {

    weak var viewController: SearchViewController?
    var dataStore: SearchDataStore

    init(viewController: SearchViewController,
         dataStore: SearchDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

}

// MARK: - SearchRoutingLogic implementation
extension SearchRouter: SearchRoutingLogic {

    func navigate(to destination: SearchRoutingDestination) {
        switch destination {
        case .details(let repositoryName, let userName):
            self.navigateToDetails(with: repositoryName, userName: userName)
        }
    }
    
    private func navigateToDetails(with repositoryName: String, userName: String) {
        guard let navigationController = viewController?.navigationController else { return }
        let detailsViewController = DetailsFactory().make(userName: userName, repositoryName: repositoryName)
        
        navigationController.pushViewController(detailsViewController, animated: true)
    }

}

// MARK: - SearchDataPassing implementation
extension SearchRouter: SearchDataPassing {
}
