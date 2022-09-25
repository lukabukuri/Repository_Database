//
//  SearchWorker.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import Foundation

protocol SearchWorker {
    func fetchUserRepositories(with userName: String, pageNumber: Int) async throws -> [UserRepository]
}

final class SearchDefaultWorker: SearchWorker {
    
    func fetchUserRepositories(with userName: String, pageNumber: Int) async throws -> [UserRepository] {
        
        let url = try constructURL(with: userName, pageNumber: pageNumber)
        return try await NetworkManager.shared.fetch(url: url)
    }
    
}


extension SearchDefaultWorker {
    
    private func constructURL(with userName: String, pageNumber: Int) throws -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.path = Keys.Endpoints.userRepositories(text: userName)
        urlComponents.queryItems = [
            URLQueryItem(name: Keys.QueryParams.page, value: String(pageNumber)),
            //URLQueryItem(name: Keys.QueryParams.perPage, value: "10")
        ]
        
        guard let path = urlComponents.url?.absoluteString,
              let url = URL(string: Constants.URL.baseURL + path) else { throw NetworkError.invalidURL }
        
        return url
    }
    
    struct Keys {
        
        struct Endpoints {
            static func userRepositories(text: String) -> String {
                return "/users/\(text)/repos"
            }
        }
        
        struct QueryParams {
            static let page = "page"
            static let perPage = "per_page"
        }
    }
}

