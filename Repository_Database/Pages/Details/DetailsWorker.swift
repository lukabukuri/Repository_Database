//
//  DetailsWorker.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.

import Foundation

protocol DetailsWorker {
    func fetchRepository(userName: String, repositoryName: String) async throws -> Repository
}

final class DetailsDefaultWorker: DetailsWorker {
    
    func fetchRepository(userName: String, repositoryName: String) async throws -> Repository {
        
        let url = try constructURL(userName: userName, repositoryName: repositoryName)
        return try await NetworkManager.shared.fetch(url: url)
    }
}


extension DetailsDefaultWorker {
    
    private func constructURL(userName: String, repositoryName: String) throws -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.path = Keys.Endpoints.repository(userName: userName, repositoryName: repositoryName)
        
        guard let path = urlComponents.url?.absoluteString,
              let url = URL(string: Constants.URL.baseURL + path) else { throw NetworkError.invalidURL }
        
        return url
    }
    
    struct Keys {
        
        struct Endpoints {
            static func repository(userName: String, repositoryName: String) -> String {
                return "/repos/\(userName)/\(repositoryName)"
            }
        }

    }
}
