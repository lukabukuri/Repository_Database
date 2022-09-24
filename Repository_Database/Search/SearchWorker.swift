//
//  SearchWorker.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import Foundation

protocol SearchWorker {
    func fetchUserRepositories(with text: String) async throws -> [UserRepository]
}

final class SearchDefaultWorker: SearchWorker {
    
    func fetchUserRepositories(with text: String) async throws -> [UserRepository] {
        
        let url = try constructURL(with: text)
        return try await NetworkManager.shared.fetch(url: url)
    }
    
    private func constructURL(with text: String) throws -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.path = Keys.Paths.userRepositories(text: text)
        urlComponents.queryItems = [
            URLQueryItem(name: Keys.QueryParams.page, value: "1"),
            URLQueryItem(name: Keys.QueryParams.perPage, value: "10")
        ]
        
        guard let path = urlComponents.url?.absoluteString,
              let url = URL(string: Constants.URL.baseURL + path) else { throw NetworkError.invalidURL }
        
        return url
    }
}


extension SearchDefaultWorker {
    
    struct Keys {
        
        struct Paths {
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

