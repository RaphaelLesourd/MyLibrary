//
//  UserModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//
import Foundation
import Combine
import FirebaseFirestoreSwift

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    private let diffableId = UUID()
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

extension UserModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(diffableId)
    }
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.diffableId == rhs.diffableId
    }
}
