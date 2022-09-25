//
//  StarredModels.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.

import UIKit

enum StarredModels {

    enum Request {
        case viewDidLoad
    }

    enum Response {
        case repositories([Repository])
        case error(Error)
    }

    enum ViewModel {
        case repositories([UserRepository])
        case error(Error)
    }

}
