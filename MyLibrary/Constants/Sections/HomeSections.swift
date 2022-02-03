//
//  Sections.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

/// HomeController CollectionView sections 
enum HomeCollectionViewSections: Int, CaseIterable {
    case categories
    case newEntry
    case favorites
    case recommanding
    case users
    
    var title: String {
        switch self {
        case .newEntry:
            return Text.SectionTitle.latestBook
        case .categories:
            return Text.SectionTitle.userCategories
        case .favorites:
            return Text.SectionTitle.favoritetBook
        case .recommanding:
            return ""
        case .users:
            return Text.SectionTitle.userRecommandation
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .newEntry, .favorites, .users:
            return Text.ButtonTitle.seeAll
        case .categories:
            return Text.ButtonTitle.manage
        case .recommanding:
            return ""
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
        case .users:
            return 4
        case .recommanding:
            return 3
        }
    }
 
    var sectionDataQuery: BookQuery? {
        switch self {
        case .categories, .recommanding:
           return nil
        case .newEntry:
            return BookQuery.latestBookQuery
        case .favorites:
            return BookQuery.favoriteBookQuery
        case .users:
            return BookQuery.recommendationQuery
        }
    }
}
