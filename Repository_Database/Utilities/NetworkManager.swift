//
//  NetworkManager.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 23.09.22.
//

import Foundation

final class NetworkManager {
    
    private init() {}
    
    static let shared = NetworkManager()
    
    func fetch<T: Decodable>(url: URL) async throws -> T {
        
        var data: Data
        var response: URLResponse
        
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw NetworkError.noInternet
        }
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.errorDecodingData
        }
        
        return object
    }
}

