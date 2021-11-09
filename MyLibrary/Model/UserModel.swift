//
//  UserModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct CurrentUser: Codable {
    @DocumentID var id: String?
    var userId: String
    var displayName: String
    var email: String
    var photoURL: String
}
