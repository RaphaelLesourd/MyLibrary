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
    case followedUsers
    case recommanding
    
    var title: String {
        switch self {
        case .newEntry:
            return Text.SectionTitle.latestBook
        case .categories:
            return Text.ControllerTitle.category
        case .favorites:
            return Text.SectionTitle.favoritetBook
        case .recommanding:
            return Text.SectionTitle.userRecommandation
        case .followedUsers:
            return "Users recommending"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .newEntry, .favorites, .recommanding:
            return Text.ButtonTitle.seeAll
        case .categories:
            return Text.ButtonTitle.manage
        case .followedUsers:
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
        case .followedUsers:
            return 3
        case .recommanding:
            return 4
        }
    }
 
    var sectionDataQuery: BookQuery? {
        switch self {
        case .categories, .followedUsers:
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
