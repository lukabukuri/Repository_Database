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
        case .fetchedRepository(let repository, let isSavedInLocalStorage):
            self.present(repository: repository, isSavedInLocalStorage)
        case .didRepositorySave(let state):
            self.presentRepositorySavingState(isSaved: state)
        case .error(let error):
            self.present(error: error)
        }
    }
    
    private func present(repository: Repository, _ isSavedInLocalStorage: Bool) {
        self.displayLogic?.display(viewModel: .repository(repository, isSavedInLocalStorage: isSavedInLocalStorage))
    }
    
    private func presentRepositorySavingState(isSaved: Bool) {
        let image: UIImage?
        if isSaved {
            image = .init(symbol: .starFill)
        } else {
            image = .init(symbol: .star)
        }
        
        self.displayLogic?.display(viewModel: .didRepositorySave(image))
    }

    private func present(error: Error) {
        self.displayLogic?.display(viewModel: .error(error))
    }

}
