//
//  FirebaseKeys.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

enum ApiKeys {
    static var fcmKEY = ""
}

enum ApiUrl {
    static var googleBooksURL = ""
    static var fcmURL = ""
}

enum CollectionDocumentKey: String, CaseIterable {
    case books
    case users
    case recommanded
    case category
    case comments
    case keys
}

enum DocumentKey: String {
    case id
    case displayName
    case email
    case photoURL
    case timestamp
    case bookID
    case favorite
    case recommanding
    case title = "volumeInfo.title"
    case author = "VolumeInfo.author"
    case category
    case name
    case fcmToken
    case ownerID
    case userID
}

enum StorageKey: String {
    case images
    case profileImage
    case badge
}

enum UserDefaultKey: String {
    case bookListMenuLayout
}
