//
//  FirebaseKeys.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

enum Keys {
    static var fcmKEY = String()
    static var feedbackEmail = String()
}

enum ApiUrl {
    static var googleBooksURL = String()
    static var fcmURL = String()
}

enum CollectionDocumentKey: String, CaseIterable {
    case books
    case users
    case recommanded
    case category
    case comments
    case keys
    case followedUsers
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
    case author = "volumeInfo.authors"
    case category
    case name
    case color
    case fcmToken
    case ownerID
    case userID
    case rating = "volumeInfo.ratingsCount"
    case publishedDate = "volumeInfo.publishedDate"
}

enum StorageKey: String {
    case images
    case profileImage
    case badge
    case recommendingSwitch
}

enum UserDefaultKey: String {
    case bookListMenuLayout
    case onboardingSeen
}
