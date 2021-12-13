//
//  Constants.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit

enum CategoryActionType {
    case delete
    case edit
    
    var title: String {
        switch self {
        case .delete:
            return Text.ButtonTitle.delete
        case .edit:
            return Text.ButtonTitle.edit
        }
    }
    
    var color: UIColor {
        switch self {
        case .delete:
            return .systemRed
        case .edit:
            return .systemOrange
        }
    }
    
    var icon: UIImage {
        switch self {
        case .delete:
            return Images.trashCircleIcon
        case .edit:
            return Images.editCircleIcon
        }
    }
}

enum SearchType {
    case librarySearch
    case apiSearch
    case barCodeSearch
}

enum AccountInterfaceType {
    case login
    case signup
    case deleteAccount
}

enum AlertBannerType {
    case error
    case success
    case customMessage(String)
    
    var message: String {
        switch self {
        case .error:
            return Text.Banner.errorTitle
        case .success:
            return Text.Banner.successTitle
        case .customMessage(let message):
            return message
        }
    }
}

enum CodeType {
    case language
    case currency
}
