//
//  BookQuery.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

import Foundation

struct BookQuery {
    let limit: Int
    let listType: HomeCollectionViewSections?
    let orderedBy: BookDocumentKey
    let descending: Bool
    
    static let latestBookQuery     = BookQuery(limit: 20, listType: .newEntry, orderedBy: .timestamp, descending: true)
    static let favoriteBookQuery   = BookQuery(limit: 20, listType: .favorites, orderedBy: .timestamp, descending: true)
    static let recommandationQuery = BookQuery(limit: 20, listType: .recommanding, orderedBy: .timestamp, descending: true)
    static let defaultAllBookQuery = BookQuery(limit: 20, listType: nil, orderedBy: .title, descending: false)
}
