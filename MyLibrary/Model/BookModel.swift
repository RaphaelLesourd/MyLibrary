//
//  BookModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 29/10/2021.
//

import Foundation
import Combine
import FirebaseFirestoreSwift

// MARK: - BookModel
struct BookModel: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    @DocumentID var id: String?
    private let diffableId = UUID()
    var etag: String
    let favorite: Bool?
    var ownerID: String?
    var recommanding: Bool?
    var volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let timestamp: Double?
    let category: [String]?
    
    private enum CodingKeys : String, CodingKey {
        case etag, volumeInfo, saleInfo, favorite, timestamp, recommanding, ownerID, category
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

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publisher, publishedDate, volumeInfoDescription: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let pageCount: Int?
    let ratingsCount: Int?
    var imageLinks: ImageLinks?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case title, authors, publisher, publishedDate
        case volumeInfoDescription = "description"
        case industryIdentifiers, pageCount, ratingsCount, imageLinks, language
    }
}

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Codable {
    let identifier: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    var thumbnail: String?
}

// MARK: - SaleInfo
struct SaleInfo: Codable {
    let retailPrice: SaleInfoListPrice?
}

// MARK: - SaleInfoListPrice
struct SaleInfoListPrice: Codable {
    let amount: Double?
    let currencyCode: String?
}
