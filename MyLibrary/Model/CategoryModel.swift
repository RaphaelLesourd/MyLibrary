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
    private let diffableId = UUID()
    var name: String?
   
    private enum CodingKeys : String, CodingKey {
        case name
    }
}

extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(diffableId)
    }
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.diffableId == rhs.diffableId
    }
}
