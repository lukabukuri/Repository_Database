//
//  BundleExtension.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 26.09.22.
//

import Foundation

var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {

override func localizedString(forKey key: String,
                              value: String?,
                              table tableName: String?) -> String {

    guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
        let bundle = Bundle(path: path) else {

            return super.localizedString(forKey: key, value: value, table: tableName)
    }

    return bundle.localizedString(forKey: key, value: value, table: tableName)
  }
}

extension Bundle {

class func setLanguage(_ language: String) {

    defer {

        object_setClass(Bundle.main, AnyLanguageBundle.self)
    }

    objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
}


enum Language: String, CaseIterable {
    case ka
    case en
}
