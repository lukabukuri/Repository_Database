//
//  UIDeviceExtentions.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.
//

import UIKit


extension UIDevice {
    
    static var isLandscape: Bool {
        UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
}

