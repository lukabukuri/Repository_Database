//
//  SearchModels.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//


enum SearchModels {

    enum Request {
        case loadRepositories(with: String, isPagination: Bool? = false, pageNumber: Int = 1)
    }

    enum Response {
        case fetchedRepositories([UserRepository])
        case error(Error)
    }

    enum ViewModel {
        case repositories([UserRepository], isFullyFetched: Bool)
        case error(Error)
    }

}
