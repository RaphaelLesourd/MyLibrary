//
//  UserModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import Foundation

protocol FirebaseConvertable {
  func toDocument() -> [String: Any]
}

struct CurrentUser {
    var id: String
    var displayName: String
    var email: String
    var photoURL: String
}

extension CurrentUser: FirebaseConvertable {
    func toDocument() -> [String : Any] {
        [UserDocumentKey.id.rawValue: self.id,
         UserDocumentKey.username.rawValue: self.displayName,
         UserDocumentKey.email.rawValue: self.email,
         UserDocumentKey.photoURL.rawValue: self.photoURL]
    }
    init?(firebaseUser document: [String: Any]) {
        guard let id = document[UserDocumentKey.id.rawValue] as? String,
              let displayName = document[UserDocumentKey.username.rawValue] as? String,
              let email = document[UserDocumentKey.email.rawValue] as? String,
              let photoURL = document[UserDocumentKey.photoURL.rawValue] as? String else { return nil }
        self.init(id: id, displayName: displayName, email: email, photoURL: photoURL)
    }
}
