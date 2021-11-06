//
//  FirebaseKeys.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

import Foundation

enum CollectionDocumentKey: String {
    case books
    case snippets
    case users
}

enum UserDocumentKey: String {
    case id
    case username
    case email
    case photoURL
}

enum BookDocumentKey: String {
    case date
    case id
    case etag
    case title
    case authors
    case publisher
    case publisherDate
    case description
    case isbn
    case pageCount
    case category
    case rating
    case photoURL
    case language
    case retailPrice
    case currencyCode
    
    case ownerReview
    case favorite
    case recommanded
}
