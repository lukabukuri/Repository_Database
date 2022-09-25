//
//  DetailsPresenter.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.


import UIKit

protocol DetailsPresentationLogic {
    func present(response: DetailsModels.Response)
}

final class DetailsPresenter {

    weak var displayLogic: DetailsDisplayLogic?

    init(displayLogic: DetailsDisplayLogic) {
        self.displayLogic = displayLogic
    }

}

// MARK: - DetailsPresentationLogic implementation
extension DetailsPresenter: DetailsPresentationLogic {

    func present(response: DetailsModels.Response) {
        switch response {
        case .fetchedRepository(let repository):
            self.present(repository: repository)
        case .error(let error):
            self.present(error: error)
        }
    }
    
    private func present(repository: Repository) {
        self.displayLogic?.display(viewModel: .repository(repository))
    }

    private func present(error: Error) {
        self.displayLogic?.display(viewModel: .error(error))
    }

}
