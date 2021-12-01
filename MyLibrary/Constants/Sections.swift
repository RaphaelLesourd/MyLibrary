//
//  Sections.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

import Foundation

/// Enum giving name to each section of the HomeController CollectionView for better readability
enum HomeCollectionViewSections: Int, CaseIterable {
    
    case categories
    case newEntry
    case favorites
    case recommanding

    var title: String {
        switch self {
        case .newEntry:
            return "Derniers ajouts"
        case .categories:
            return "Catégories"
        case .favorites:
            return "Favoris"
        case .recommanding:
            return "Recommandations"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .newEntry, .favorites, .recommanding:
            return "Tout voir"
        case .categories:
            return "Manage"
        }
    }
}

enum SingleSection: Int, CaseIterable {
    case main
}

enum CommentsSection: CaseIterable {
    
    case book
    case today
    case past
    var headerTitle: String {
        switch self {
        case .book:
            return ""
        case .today:
            return "Aujourd'hui"
        case .past:
            return "Depuis hier"
        }
    }
}
