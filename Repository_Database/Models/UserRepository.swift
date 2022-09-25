//
//  UserRepository.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 23.09.22.
//

import Foundation

struct UserRepository: Decodable {
    
    var repositoryName: String?
    var owner: Owner?
    var image: Data?
    
    private enum CodingKeys: String, CodingKey {
        case repositoryName = "name", owner
    }
    
}

struct Owner: Decodable {
    
    var userName: String?
    var avatarURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "login", avatarURL = "avatar_url"
    }
}
