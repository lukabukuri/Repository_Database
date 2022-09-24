//
//  UIImageExtentions.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 22.09.22.
//

import UIKit

extension UIImage {
    
    convenience init?(symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
    
}
