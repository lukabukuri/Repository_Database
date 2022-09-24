//
//  UITableViewExtentions.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 23.09.22.
//

import UIKit

extension UITableView {
    
    func registerClass<T: UITableViewCell>(class: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func deque<T: UITableViewCell>(_ classType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
    
}

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
