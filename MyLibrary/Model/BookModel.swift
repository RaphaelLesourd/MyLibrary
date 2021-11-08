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
struct Item: Codable, Identifiable {
    @DocumentID var id: String?
    let diffableId = UUID()
    let etag: String?
    let favorite: Bool?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    
    private enum CodingKeys : String, CodingKey {
        case etag, volumeInfo, saleInfo, favorite
    }
    
    func createSnippet(with id: String) -> BookSnippet {
        return BookSnippet(etag: id,
                           timestamp: Date().timeIntervalSince1970,
                           title: volumeInfo?.title,
                           author: volumeInfo?.authors?.first,
                           photoURL: volumeInfo?.imageLinks?.thumbnail,
                           description: volumeInfo?.volumeInfoDescription,
                           favorite: false)
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
    let smallThumbnail, thumbnail: String?
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
