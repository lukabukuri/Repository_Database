//
//  DetailsInteractor.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.



protocol DetailsBusinessLogic {
    func process(request: DetailsModels.Request)
}

protocol DetailsDataStore {
    var userName: String? { get set }
    var repositoryName: String? { get set }
}

final class DetailsInteractor {

    var worker: DetailsWorker
    var presenter: DetailsPresentationLogic
    
    var userName: String?
    var repositoryName: String?

    init(worker: DetailsWorker,
         presenter: DetailsPresentationLogic) {
        self.worker = worker
        self.presenter = presenter
    }
    
}

// MARK: - DetailsBusinessLogic implementation
extension DetailsInteractor: DetailsBusinessLogic {

    func process(request: DetailsModels.Request) {
        switch request {
        case .viewDidLoad:
            self.processViewDidLoad()
        }
    }

    private func processViewDidLoad() {
        guard let userName, let repositoryName else { return }
        Task {
            do {
                let repository = try await self.worker.fetchRepository(userName: userName, repositoryName: repositoryName)
                self.presenter.present(response: .fetchedRepository(repository))
            } catch {
                self.presenter.present(response: .error(error))
            }
        }
    }
    
}

// MARK: - DetailsDataStore implementation
extension DetailsInteractor: DetailsDataStore {
}
