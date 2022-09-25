//
//  StarredPresenter.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.


import UIKit

protocol StarredPresentationLogic {
    func present(response: StarredModels.Response)
}

final class StarredPresenter {
    
    weak var displayLogic: StarredDisplayLogic?
    
    init(displayLogic: StarredDisplayLogic) {
        self.displayLogic = displayLogic
    }
    
}

// MARK: - StarredPresentationLogic implementation
extension StarredPresenter: StarredPresentationLogic {
    
    func present(response: StarredModels.Response) {
        switch response {
        case .repositories(let repositories):
            self.present(repositories: repositories)
        case .error(let error):
            self.present(error: error)
        }
    }
    
    private func present(repositories: [Repository]) {
        var userRepositories = [UserRepository]()
        
        for repository in repositories {
            userRepositories.append(UserRepository(
                repositoryName: repository.repositoryName,
                owner: Owner(userName: repository.owner?.userName),
                image: repository.profileImage))}
        self.displayLogic?.display(viewModel: .repositories(userRepositories))
    }
    
    private func present(error: Error) {
        self.displayLogic?.display(viewModel: .error(error))
    }
    
}
