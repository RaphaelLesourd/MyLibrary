//
//  CategoryModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 17/11/2021.
//

import FirebaseFirestoreSwift

struct CategoryDTO: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    var name: String
    var color: String
   
    private enum CodingKeys : String, CodingKey {
        case uid, name, color
    }
}

extension CategoryDTO: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    static func == (lhs: CategoryDTO, rhs: CategoryDTO) -> Bool {
        return lhs.uid == rhs.uid
        && lhs.name == rhs.name
        && lhs.color == rhs.color
    }
}
