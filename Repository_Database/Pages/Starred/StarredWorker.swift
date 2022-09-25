//
//  StarredWorker.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.


import UIKit

protocol StarredWorker {
    func loadRepositoriesFromLocalStorage(completion: @escaping ([Repository]) -> Void)
}

final class StarredDefaultWorker: StarredWorker {
    
    let persistentManager: PersistentManagerProtocol
    
    init (persistentManager: PersistentManagerProtocol) {
        self.persistentManager = persistentManager
    }
    
    func loadRepositoriesFromLocalStorage(completion: @escaping ([Repository]) -> Void) {
        
        var userRepositories = [Repository]()
        let repositoryEntity = RepositoryEntity(context: persistentManager.context)
        
        persistentManager.read(with: repositoryEntity) { repositories in
            for repository in repositories {
                if let repository = repository as? RepositoryEntity, repository.name != nil {
                    userRepositories.append(
                        Repository(repositoryName: repository.name,
                                   description: repository.repositoryDescription,
                                   dateCreated: repository.creationDate,
                                   programmingLanguage: repository.programmingLanguage,
                                   profileImage: repository.image,
                                   owner: Owner(userName: repository.userName)
                    ))
                }
            }
            completion(userRepositories)
            
        }
    }
}
