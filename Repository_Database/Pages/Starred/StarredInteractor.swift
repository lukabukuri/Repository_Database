//
//  StarredInteractor.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.
//


protocol StarredBusinessLogic {
    func process(request: StarredModels.Request)
}

protocol StarredDataStore {
    var repositories: [Repository] { get set }
}

final class StarredInteractor {

    var worker: StarredWorker
    var presenter: StarredPresentationLogic

    var repositories = [Repository]()
    init(worker: StarredWorker,
         presenter: StarredPresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
    
}

// MARK: - StarredBusinessLogic implementation
extension StarredInteractor: StarredBusinessLogic {

    func process(request: StarredModels.Request) {
        switch request {
        case .viewDidLoad:
            self.processViewDidLoad()
        }
    }

    private func processViewDidLoad() {
        self.worker.loadRepositoriesFromLocalStorage { [weak self] repositories in
            self?.repositories = repositories
            self?.presenter.present(response: .repositories(repositories))
            
        }
    }

}

// MARK: - StarredDataStore implementation
extension StarredInteractor: StarredDataStore {
}
