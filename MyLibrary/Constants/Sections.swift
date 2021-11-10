//
//  Sections.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

import Foundation

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
