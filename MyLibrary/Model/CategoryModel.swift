//
//  CategoryModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct Category: Codable {
    @DocumentID var id: String?
    let uid: String?
    var name: String?
   
    private enum CodingKeys : String, CodingKey {
        case uid, name
    }
}

extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.uid == rhs.uid && lhs.name == rhs.name
    }
}
