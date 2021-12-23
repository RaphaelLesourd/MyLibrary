//
//  QueryTypes.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//

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
