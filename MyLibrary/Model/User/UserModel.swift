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

struct NewUser {
    var userName: String?
    var email: String
    var password: String
    var confirmPassword: String?
}

struct CurrentUser {
    var id: String
    var displayName: String
    var email: String
    var photoURL: String
}

extension CurrentUser: FirebaseConvertable {
    func toDocument() -> [String : Any] {
        [ "id": self.id,
          "displayName": self.displayName,
          "email": self.email,
          "photoURL": self.photoURL
        ]
    }
    init?(from document: [String: Any]) {
        guard let id = document["uid"] as? String,
              let displayName = document["displayName"] as? String,
              let email = document["email"] as? String,
              let photoURL = document["photoURL"] as? String else { return nil }
        self.init(id: id, displayName: displayName, email: email, photoURL: photoURL)
    }
}
