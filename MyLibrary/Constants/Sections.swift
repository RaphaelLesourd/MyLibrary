//
//  Sections.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

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
    
    var buttonTag: Int {
        switch self {
        case .categories:
            return 0
        case .newEntry:
            return 1
        case .favorites:
            return 2
        case .recommanding:
            return 3
        }
    }
 
    var sectionDataQuery: BookQuery? {
        switch self {
        case .categories:
           return nil
        case .newEntry:
            return BookQuery.latestBookQuery
        case .favorites:
            return BookQuery.favoriteBookQuery
        case .recommanding:
            return BookQuery.recommendationQuery
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
            return ""
        }
    }
}
