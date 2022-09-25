//
//  NetworkError.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 26.09.22.
//

import UIKit


enum NetworkError: Error, CustomPlaceHolder {
    case badResponse, errorDecodingData, invalidURL, noInternet
    
    var icon: UIImage? {
        switch self {
        case .noInternet, .invalidURL:
            return UIImage(symbol: .wifiSlash)
        case .badResponse:
            return UIImage(symbol: .badgePerson)
        default:
            return nil
        }
    }
    
    var title: String? {
        switch self {
        case .noInternet, .invalidURL:
            return Constants.noInternet
        case .badResponse:
            return Constants.userDoesNotExist
        default:
            return nil
        }
    }
}
