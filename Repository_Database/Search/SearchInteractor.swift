//
//  SearchInteractor.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//



protocol SearchBusinessLogic {
    func process(request: SearchModels.Request)
}

protocol SearchDataStore {
}

final class SearchInteractor {

    var worker: SearchWorker
    var presenter: SearchPresentationLogic

    init(worker: SearchWorker,
         presenter: SearchPresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
    
}

// MARK: - SearchBusinessLogic implementation
extension SearchInteractor: SearchBusinessLogic {

    func process(request: SearchModels.Request) {
        switch request {
        case .searchRepositories(let text):
            self.processSearchRepositories(with: text)
        }
    }

    private func processSearchRepositories(with text: String) {
        Task {
            do {
                let repositories = try await self.worker.fetchUserRepositories(with: text)
                self.presenter.present(response: .fetchedRepositories(repositories))
            } catch {
                self.presenter.present(response: .error(error))
            }
        }
        
    }

}

// MARK: - SearchDataStore implementation
extension SearchInteractor: SearchDataStore {
}
