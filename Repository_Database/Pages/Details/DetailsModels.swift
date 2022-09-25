//
//  DetailsModels.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.

import UIKit

enum DetailsModels {

    enum Request {
        case viewDidLoad
        case saveRepository(imageData: Data? = nil)
    }

    enum Response {
        case fetchedRepository(Repository, isSavedInLocalStorage: Bool = false)
        case didRepositorySave(Bool)
        case error(Error)
    }

    enum ViewModel {
        case repository(Repository, isSavedInLocalStorage: Bool = false)
        case didRepositorySave(UIImage?)
        case error(Error)
    }

}
