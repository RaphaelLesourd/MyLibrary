//
//  CategoryModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import FirebaseFirestoreSwift

struct CategoryModel: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String?
    var name: String?
    var color: String?
   
    private enum CodingKeys : String, CodingKey {
        case uid, name, color
    }
}

extension CategoryModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.uid == rhs.uid
        && lhs.name == rhs.name
        && lhs.color == rhs.color
    }
}
