//
//  DetailsWorker.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.

import Foundation

protocol DetailsWorker {
    func saveRepositoryInLocalStorage(repository: Repository?, completion: @escaping ((Bool) -> Void))
    func removeRepositoryFromLocalStorage(repository: Repository?, completion: @escaping ((Bool) -> Void))
}

final class DetailsDefaultWorker: DetailsWorker {
    
    let persistentManager: PersistentManagerProtocol
    
    init (persistentManager: PersistentManagerProtocol) {
        self.persistentManager = persistentManager
    }
    
    func saveRepositoryInLocalStorage(repository: Repository?, completion: @escaping ((Bool) -> Void)) {
        
        guard let repository else { completion(false); return }
        
        let repositoryEntity = RepositoryEntity(context: persistentManager.context)
        repositoryEntity.name = repository.repositoryName
        repositoryEntity.userName = repository.owner?.userName
        repositoryEntity.programmingLanguage = repository.programmingLanguage
        repositoryEntity.image = repository.profileImage
        repositoryEntity.creationDate = repository.dateCreated
        repositoryEntity.repositoryDescription = repository.description
        persistentManager.create(with: repositoryEntity) { state in
            completion(state)
        }
    }
    
    func removeRepositoryFromLocalStorage(repository: Repository?, completion: @escaping ((Bool) -> Void)) {
        
        guard let repositoryName = repository?.repositoryName else { completion(false); return }
        
        let repositoryEntity = RepositoryEntity(context: persistentManager.context)
        persistentManager.delete(with: repositoryEntity, predicate: repositoryName) { state in
            completion(state)
        }
    }

}



