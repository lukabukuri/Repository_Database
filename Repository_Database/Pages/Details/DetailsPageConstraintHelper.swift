//
//  DetailsPageConstraintHelper.swift
//  Repository_Database
//
//  Created by Luka Bukuri on 25.09.22.
//

import UIKit


enum DetailsPageConstraintHelper {
    
    // Avatar Image View
    static var avatarImageViewHeight: CGFloat = 100
    static let avatarImageViewWidth: CGFloat = 100
    
    static var avatarImageViewTop: CGFloat {
        UIDevice.isLandscape ? 50 : 180
    }
    
    // Author Name Label
    static var authorLabelTop: CGFloat {
        UIDevice.isLandscape ? 160 : 290
    }
    
    // Repository Name Label
    static var repositoryNameLabelLeft: CGFloat {
        UIDevice.isLandscape ? 50 : 20

    }
    static var repositoryNameLabelRight: CGFloat {
        UIDevice.isLandscape ? (UIScreen.main.bounds.width / 2 + 50) : 20
    }
    static var repositoryNameLabelTop: CGFloat {
        UIDevice.isLandscape ? 70 : 350
    }
    
    // Programming Language Label
    static var programmingLanguageLabelLeft: CGFloat {
        UIDevice.isLandscape ? 50 : 20

    }
    static var programmingLanguageLabelTop: CGFloat {
        UIDevice.isLandscape ? 110 : 400
    }
    
    // Date Label
    static var dateLabelLeft: CGFloat {
        UIDevice.isLandscape ? 50 : 20

    }
    static var dateLabelTop: CGFloat {
        UIDevice.isLandscape ? 150 : 430
    }
    
    // Description Label
    static let descriptionLabelLeft: CGFloat = 20
    static let descriptionLabelRight: CGFloat = 20
    static var descriptionLabelTop: CGFloat {
        UIDevice.isLandscape ? 190 : 480
    }
    
    // Save Button
    static let saveButtonHeight: CGFloat = 60
    static let saveButtonWidth: CGFloat = 60
    static var saveButtonTop: CGFloat {
        UIDevice.isLandscape ? 260 : 550
    }
}
