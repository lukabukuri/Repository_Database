//
//  PersistentManager.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.
//

import UIKit
import CoreData

protocol PersistentManagerProtocol: BasePersistentProtocol {
    func create<T: NSManagedObject>(with object: T, completion: @escaping ((Bool) -> Void))
    func read<T: NSManagedObject>(with object: T, completion: @escaping (([NSManagedObject]) -> Void))
    func update<T: NSManagedObject>(with object: T, completion: @escaping ((Bool) -> Void))
    func delete<T: NSManagedObject>(with object: T, predicate: String, completion: @escaping ((Bool) -> Void))
}

final class PersistentManager: PersistentManagerProtocol {
   
    var context: NSManagedObjectContext!

    func create<T: NSManagedObject>(with object: T, completion: @escaping ((Bool) -> Void)) {
        
        do {
            try context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func read<T: NSManagedObject>(with object: T, completion: @escaping (([NSManagedObject]) -> Void)) {
        do {
            let request = NSFetchRequest<NSManagedObject>(entityName: object.entity.name ?? .empty)
            let result = try context.fetch(request)
            return completion(result)
        } catch {
            print(error)
        }

    }
    
    func update<T: NSManagedObject>(with object: T, completion: @escaping ((Bool) -> Void)) {
        //let request = NSFetchRequest<NSManagedObject>(entityName: object.entity.name ?? .empty)
        
    }
    
    func delete<T: NSManagedObject>(with object: T, predicate: String, completion: @escaping ((Bool) -> Void)) {
        
        let request = NSFetchRequest<NSManagedObject>(entityName: object.entity.name ?? .empty)
        request.predicate = NSPredicate(format: "name == %@", "\(predicate)")
        
        do {
            let objects = try context.fetch(request)
            for object in objects {
                context.delete(object)
            }
            try context.save()
            completion(true)
        } catch {
            completion(false)
        }
    }
}
