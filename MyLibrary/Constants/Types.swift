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
            return Images.EditIcon.trashCircleIcon
        case .edit:
            return Images.EditIcon.editCircleIcon
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

enum QueryType: CaseIterable {
    case timestamp
    case title
    case authors
    case rating
    
    var title: String {
        switch self {
        case .timestamp:
            return Text.ListMenu.byTimestamp
        case .title:
            return Text.ListMenu.byTitle
        case .authors:
            return Text.ListMenu.byAuthor
        case .rating:
            return Text.ListMenu.byRating
        }
    }
    
    var documentKey: DocumentKey {
        switch self {
        case .timestamp:
            return .timestamp
        case .title:
            return .title
        case .authors:
            return .author
        case .rating:
            return .rating
        }
    }
}
