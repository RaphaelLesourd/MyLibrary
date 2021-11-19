//
//  BookQuery.swift
//  MyLibrary
//
//  Created by Birkyboy on 09/11/2021.
//

import Foundation

struct BookQuery {
    let listType  : HomeCollectionViewSections?
    let orderedBy : DocumentKey
    let fieldValue: String?
    let descending: Bool
    
    static let latestBookQuery     = BookQuery(listType: .newEntry, orderedBy: .timestamp, fieldValue: nil, descending: true)
    static let favoriteBookQuery   = BookQuery(listType: .favorites, orderedBy: .timestamp, fieldValue: nil, descending: true)
    static let recommendationQuery = BookQuery(listType: .recommanding, orderedBy: .timestamp, fieldValue: nil, descending: true)
    static let defaultAllBookQuery = BookQuery(listType: nil, orderedBy: .title, fieldValue: nil, descending: false)
}
