//
//  UserModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import FirebaseFirestoreSwift

struct UserModel: Codable {
    @DocumentID var id: String?
    var userId: String
    var displayName: String
    var email: String
    var photoURL: String
    var token: String
    
    private enum CodingKeys : String, CodingKey {
        case userId, displayName, email, photoURL
        case token = "fcmToken"
    }
}
