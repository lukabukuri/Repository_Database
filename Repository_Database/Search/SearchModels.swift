//
//  SearchModels.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//


enum SearchModels {

    enum Request {
        case searchRepositories(with: String)
    }

    enum Response {
        case fetchedRepositories([UserRepository])
        case error(Error)
    }

    enum ViewModel {
        case repositories([UserRepository])
        case error(Error)
    }

}
