//
//  SearchRouter.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//


enum SearchRoutingDestination {
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
//        switch destination {
//        }
    }

}

// MARK: - SearchDataPassing implementation
extension SearchRouter: SearchDataPassing {
}
