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
    case recommanded
    case category
    case comments
}

enum DocumentKey: String {
    case id
    case username = "displayName"
    case email
    case photoURL
    case timestamp
    case bookID
    case favorite
    case recommanding
    case title = "volumeInfo.title"
    case category
    case name
    case fcmToken
}

enum StorageKey: String {
    case images
    case profileImage
}
