//
//  Constants.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation

/// Enum giving name to each section of the HomeController CollectionView for better readability
enum HomeCollectionViewSections: Int, CaseIterable {
    case categories
    case newEntry
    case favorites
    case recommanding
}

enum SearchCollectionViewSections: Int, CaseIterable {
    case librarySearch
    case apiSearch
}

enum AccountInterfaceType {
    case login
    case signup
}

enum AlertBannerType {
    case error
    case success
    case custom(String)
    
    var message: String {
        switch self {
        case .error:
            return "Erreur!"
        case .success:
            return "Succés"
        case .custom(let message):
            return message
        }
    }
}
