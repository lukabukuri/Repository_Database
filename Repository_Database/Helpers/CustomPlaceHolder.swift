//
//  CustomPlaceHolder.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 26.09.22.
//

import UIKit

protocol CustomPlaceHolder {
    var icon: UIImage? { get }
    var title: String? { get }
}

enum DefaultPlaceHolder: CustomPlaceHolder {
    case emptySearch
    case emptyFavorites
    
    var icon: UIImage? {
        switch self {
        case .emptySearch:
            return UIImage(symbol: .magnifyingGlass)
        case .emptyFavorites:
            return UIImage(symbol: .listStar)
        }
    }
    
    var title: String? {
        switch self {
        case .emptySearch:
            return Constants.searchRepositories
        case .emptyFavorites:
            return Constants.noStarredRepositories
        }
    }
}
