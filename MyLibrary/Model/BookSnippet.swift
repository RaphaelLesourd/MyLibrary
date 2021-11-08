//
//  BookSnippet.swift
//  MyLibrary
//
//  Created by Birkyboy on 07/11/2021.
//

import Foundation
import Combine
import FirebaseFirestoreSwift

struct BookSnippet: Codable, Identifiable {
    @DocumentID var id: String?
    let etag: String?
    let timestamp: Double?
    let title: String?
    let author: String?
    let photoURL: String?
    let description: String?
    let favorite: Bool?
    let diffableId = UUID()
    
    private enum CodingKeys : String, CodingKey {
        case etag, timestamp ,title ,author ,photoURL ,description, favorite
    }
}
extension BookSnippet: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(diffableId)
    }
    static func == (lhs: BookSnippet, rhs: BookSnippet) -> Bool {
        return lhs.diffableId == rhs.diffableId
    }
}
