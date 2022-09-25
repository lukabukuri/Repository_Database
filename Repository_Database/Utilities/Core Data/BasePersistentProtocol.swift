//
//  BasePersistentProtocol.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.
//

import UIKit
import CoreData


protocol BasePersistentProtocol: AnyObject {
    var context: NSManagedObjectContext! { get }
}

extension BasePersistentProtocol {

    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
