//
//  CommentModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/11/2021.
//

import FirebaseFirestoreSwift

struct CommentModel: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    let userID: String
    let userName: String
    let userPhotoURL: String
    let message: String
    let timestamp: Double
    
    private enum CodingKeys : String, CodingKey {
        case uid, userID, userName, userPhotoURL, timestamp
        case message = "comment"
    }
}
extension CommentModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    static func == (lhs: CommentModel, rhs: CommentModel) -> Bool {
        return lhs.uid == rhs.uid && lhs.message == rhs.message
    }
}
