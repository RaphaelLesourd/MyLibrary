//
//  CommentModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/11/2021.
//

import FirebaseFirestoreSwift

struct CommentModel: Codable {
    @DocumentID var id: String?
    let uid: String?
    let userID: String?
    let comment: String?
    let timestamp: Double?
    
    private enum CodingKeys : String, CodingKey {
        case uid, userID, comment, timestamp
    }
}
extension CommentModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    static func == (lhs: CommentModel, rhs: CommentModel) -> Bool {
        return lhs.uid == rhs.uid && lhs.comment == rhs.comment
    }
}
