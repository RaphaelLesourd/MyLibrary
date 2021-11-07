//
//  Item.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/11/2021.
//

import Foundation
import Combine
import FirebaseFirestoreSwift

// MARK: - Item
struct Item: Codable, Identifiable {
    @DocumentID var id: String?
    let diffableId = UUID()
    let etag: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    
    private enum CodingKeys : String, CodingKey {
        case etag, volumeInfo, saleInfo
    }
    
    func createSnippet(with id: String) -> BookSnippet {
        return BookSnippet(id: id,
                           timestamp: Date().timeIntervalSince1970,
                           title: volumeInfo?.title,
                           author: volumeInfo?.authors?.first,
                           photoURL: volumeInfo?.imageLinks?.thumbnail,
                           description: volumeInfo?.volumeInfoDescription)
    }
}

extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(diffableId)
    }
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.diffableId == rhs.diffableId
    }
}
