//
//  Repository.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 23.09.22.
//

import Foundation

struct Repository: Decodable {
    
    var name: String?
    var description: String?
    var created_at: String?
    var language: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "repositoryName", description, created_at = "dateCreated", language = "programmingLanguage"
    }
    
}
