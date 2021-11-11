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
    let diffableId = UUID()
    let etag: String?
    let favorite: Bool?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    let timestamp: Double?
    
    private enum CodingKeys : String, CodingKey {
        case etag, volumeInfo, saleInfo, favorite, timestamp
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
    let categories: [String]?
    let ratingsCount: Int?
    let imageLinks: ImageLinks?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case title, authors, publisher, publishedDate
        case volumeInfoDescription = "description"
        case industryIdentifiers, pageCount, categories, ratingsCount, imageLinks, language
    }
}

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Codable {
    let identifier: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let thumbnail: String?
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
