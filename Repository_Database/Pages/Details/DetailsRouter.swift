//
//  DetailsRouter.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.



enum DetailsRoutingDestination {
}

protocol DetailsRoutingLogic {
    func navigate(to destination: DetailsRoutingDestination)
}

protocol DetailsDataPassing {
    var dataStore: DetailsDataStore { get set }
}

final class DetailsRouter {

    weak var viewController: DetailsViewController?
    var dataStore: DetailsDataStore

    init(viewController: DetailsViewController,
         dataStore: DetailsDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }

}

// MARK: - DetailsRoutingLogic implementation
extension DetailsRouter: DetailsRoutingLogic {

    func navigate(to destination: DetailsRoutingDestination) {
//        switch destination {
//        }
    }

}

// MARK: - DetailsDataPassing implementation
extension DetailsRouter: DetailsDataPassing {
}
