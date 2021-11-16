//
//  BookQuery.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

import Foundation

struct BookQuery {
    let listType: HomeCollectionViewSections?
    let orderedBy: BookDocumentKey
    let descending: Bool
    
    static let latestBookQuery     = BookQuery(listType: .newEntry, orderedBy: .timestamp, descending: true)
    static let favoriteBookQuery   = BookQuery(listType: .favorites, orderedBy: .timestamp, descending: true)
    static let recommandationQuery = BookQuery(listType: .recommanding, orderedBy: .timestamp, descending: true)
    static let defaultAllBookQuery = BookQuery(listType: nil, orderedBy: .title, descending: false)
}
