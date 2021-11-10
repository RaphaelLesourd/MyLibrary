//
//  BookQuery.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

import Foundation

struct SnippetQuery {
    let limit: Int
    let listType: HomeCollectionViewSections
    let orderedBy: BookDocumentKey
    let descending: Bool
    
    static let latestBookQuery     = SnippetQuery(limit: 20, listType: .newEntry, orderedBy: .timestamp, descending: true)
    static let favoriteBookQuery   = SnippetQuery(limit: 20, listType: .favorites, orderedBy: .timestamp, descending: true)
    static let defaultAllBookQuery = SnippetQuery(limit: 20, listType: .newEntry, orderedBy: .title, descending: false)
}
