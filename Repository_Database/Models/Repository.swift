//
//  Repository.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 23.09.22.
//

import Foundation

struct Repository: Decodable {
    
    var repositoryName: String?
    var description: String?
    var dateCreated: String?
    var programmingLanguage: String?
    var profileImage: Data?
    var owner: Owner?
    
    private enum CodingKeys: String, CodingKey {
        case repositoryName = "name", description, dateCreated = "created_at", programmingLanguage = "language", owner
    }
    
}
