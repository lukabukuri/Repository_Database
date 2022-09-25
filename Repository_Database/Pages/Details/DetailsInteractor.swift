//
//  DetailsInteractor.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.

import UIKit

protocol DetailsBusinessLogic {
    func process(request: DetailsModels.Request)
}

protocol DetailsDataStore {
    var userName: String? { get set }
    var repositoryName: String? { get set }
    var repository: Repository? { get set }
    var isRepositorySaved: Bool { get set }
    
}

final class DetailsInteractor {

    var worker: DetailsWorker & DetailsServiceWorker
    var presenter: DetailsPresentationLogic
    
    var userName: String?
    var repositoryName: String?
    
    var repository: Repository?
    var isRepositorySaved: Bool = false
    
    init(worker: DetailsWorker & DetailsServiceWorker,
         presenter: DetailsPresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
    
}

// MARK: - DetailsBusinessLogic implementation
extension DetailsInteractor: DetailsBusinessLogic {

    func process(request: DetailsModels.Request) {
        switch request {
        case .saveRepository(let imageData):
            self.processSaveRepository(with: imageData)
        case .viewDidLoad:
            self.processViewDidLoad()
        }
    }
    
    private func processSaveRepository(with imageData: Data?) {
        repository?.profileImage = imageData
        if isRepositorySaved {
            self.worker.removeRepositoryFromLocalStorage(repository: repository) { [weak self] state in
                self?.isRepositorySaved = !state
                self?.presenter.present(response: .didRepositorySave(!state))
            }
        } else {
            self.worker.saveRepositoryInLocalStorage(repository: repository) { [weak self] state in
                self?.isRepositorySaved = state
                self?.presenter.present(response: .didRepositorySave(state))
            }
        }
    }

    private func processViewDidLoad() {
        if !isRepositorySaved {
            guard let userName, let repositoryName else { return }
            Task {
                do {
                    let repository = try await self.worker.fetchRepository(userName: userName, repositoryName: repositoryName)
                    self.repository = repository
                    self.presenter.present(response: .fetchedRepository(repository))
                } catch {
                    self.presenter.present(response: .error(error))
                }
            }
        } else {
            if let repository {
                self.presenter.present(response: .fetchedRepository(repository, isSavedInLocalStorage: true))
            }
        }
    }
    
}

// MARK: - DetailsDataStore implementation
extension DetailsInteractor: DetailsDataStore {
}
