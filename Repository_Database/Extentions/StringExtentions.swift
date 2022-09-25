//
//  StrubgExtentions.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 24.09.22.
//

import Foundation

extension String {

    static var empty: String { get { return String() } }
    
    static var space: String { get { return String(" ") } }
    
    static var largeSpace: String { get { return String("    ") } }
    
    func convertISODateToString() -> Self {
        var creationDate: String = .empty
        let isoFormatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let date = isoFormatter.date(from: self)
        if let date {
            creationDate = dateFormatter.string(from: date)
        }
        
        return creationDate
    }
    
    func localized(withComment comment: String? = nil) -> String {
           return NSLocalizedString(self, comment: comment ?? "")
       }
}

