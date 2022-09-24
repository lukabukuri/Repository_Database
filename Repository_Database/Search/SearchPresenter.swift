//
//  SearchPresenter.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import UIKit

protocol SearchPresentationLogic {
    func present(response: SearchModels.Response)
}

final class SearchPresenter {

    weak var displayLogic: SearchDisplayLogic?

    init(displayLogic: SearchDisplayLogic) {
        self.displayLogic = displayLogic
    }

}

// MARK: - SearchPresentationLogic implementation
extension SearchPresenter: SearchPresentationLogic {

    func present(response: SearchModels.Response) {
        switch response {
        case .error(let error):
            self.present(error: error)
        case .fetchedRepositories(let repositories):
            self.presentRepositories(repositories)
        }
    }
    
    private func presentRepositories(_ repositories: [UserRepository]) {
        self.displayLogic?.display(viewModel: .repositories(repositories))
    }

    private func present(error: Error) {
        self.displayLogic?.display(viewModel: .error(error))
    }

}
