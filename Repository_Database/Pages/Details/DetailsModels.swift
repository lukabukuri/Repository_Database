//
//  DetailsModels.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.



enum DetailsModels {

    enum Request {
        case viewDidLoad
    }

    enum Response {
        case fetchedRepository(Repository)
        case error(Error)
    }

    enum ViewModel {
        case repository(Repository)
        case error(Error)
    }

}
