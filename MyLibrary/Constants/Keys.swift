//
//  FirebaseKeys.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

enum ApiKeys {
    // swiftlint:disable:next line_length
    static let fcmKEY = "key=AAAAREQmmeA:APA91bHTxySL1KCgdIPC8KAlwhEI7CWCzfvnqQtmwOvbVO5UJOXeJVx3qwh97opc0wDiAT9S4S8ro_AyGayzf-ym5NeDe-6giNDvzplmHvGIghrISPCDPKr5pi2VJwJjw8hunsunjZGo"
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
    case category
    case name
    case fcmToken
    case ownerID
    case userID
}

enum StorageKey: String {
    case images
    case profileImage
}

enum UserDefaultKey: String {
    case bookListMenuLayout
}
