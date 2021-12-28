//
//  UserModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import FirebaseFirestoreSwift

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userID: String
    var displayName: String
    var email: String
    var photoURL: String
    var token: String
    
    private enum CodingKeys : String, CodingKey {
        case userID, displayName, email, photoURL
        case token = "fcmToken"
    }
}
