//
//  FirebaseKeys.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

import Foundation

enum CollectionDocumentKey: String, CaseIterable {
    case books
    case users
}

enum UserDocumentKey: String {
    case id
    case username
    case email
    case photoURL
}

enum BookDocumentKey: String {
    case timestamp
    case etag
    case favorite
    case recommanding
    case title = "volumeInfo.title"
}
