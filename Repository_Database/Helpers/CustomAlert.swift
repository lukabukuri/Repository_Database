//
//  CustomAlert.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.
//

import UIKit

struct CustomAlert {
    
    var title: String?
    var message: String?
    var action: [AlertActions]
    
    init(title: String? = nil,
         message: String? = nil,
         action: [AlertActions]) {
        self.title = title
        self.message = message
        self.action = action
    }
    
}

enum AlertActions {
    // Alert action cases
    
    case yes(handler: (() -> Void)?)
    case no(handler: (() -> Void)?)
    
    
    private var title: String? {
        switch self {
        case .yes: return "Yes".localized()
        case .no: return "No".localized()
        }
    }
    
    private var handler: (() -> Void)? {
        switch self {
        case .yes(let handler): return handler
        case .no(let handler): return handler
        }
    }
    
    var alertAction: UIAlertAction {
        guard let handler = self.handler else {
            return UIAlertAction(title: title, style: .cancel, handler: nil)
        }

        return UIAlertAction(title: title, style: .default, handler: { _ in
            DispatchQueue.main.async {
               handler()
            }
        })
    }
}
