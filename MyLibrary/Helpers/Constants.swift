//
//  Constants.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import Foundation

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

public enum AlertBannerType {
    case error
    case success
    case customMessage(String)
    
    var message: String {
        switch self {
        case .error:
            return "Erreur!"
        case .success:
            return "Succés"
        case .customMessage(let message):
            return message
        }
    }
}

enum TextInputType {
    case description
    case comment
}

/// Enum giving name to each section of the HomeController CollectionView for better readability
enum HomeCollectionViewSections: Int, CaseIterable {
    case newEntry
    case favorites
    case categories
    case recommanding
    
    var title: String {
        switch self {
        case .categories:
            return "Catégories"
        case .newEntry:
            return "Derniers ajouts"
        case .favorites:
            return "Favoris"
        case .recommanding:
            return "Recommandations"
        }
    }
}

enum ApiSearchSection: Int, CaseIterable {
    case main
}

enum BookListSection: Int, CaseIterable {
    case mybooks
}
