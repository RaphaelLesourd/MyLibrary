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
   // @DocumentID public var id: String?
    let etag: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
}
extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(etag)
    }
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.etag == rhs.etag
    }
}

// MARK: - VolumeInfo
struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publisher, publishedDate, volumeInfoDescription: String?
    let industryIdentifiers: [IndustryIdentifier]?
    let pageCount: Int?
    let printType: String?
    let categories: [String]?
    let ratingsCount: Int?
    let imageLinks: ImageLinks?
    let language: String?
    let infoLink: String?

    enum CodingKeys: String, CodingKey {
        case title, authors, publisher, publishedDate
        case volumeInfoDescription = "description"
        case industryIdentifiers, pageCount, printType, categories, ratingsCount, imageLinks, language, infoLink
    }
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

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Codable {
    let type, identifier: String?
}

// MARK: - ImageLinks
struct ImageLinks: Codable {
    let smallThumbnail, thumbnail, large, extralarge: String?
}
