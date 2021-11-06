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
    let collectionItemId = UUID()
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
    
    private enum CodingKeys : String, CodingKey {
        case volumeInfo, saleInfo
    }
}

extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(collectionItemId)
    }
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.collectionItemId == rhs.collectionItemId
    }
}

extension Item {
    func toSnippet(id: String) -> [String : Any] {
        [BookDocumentKey.id.rawValue: id,
         BookDocumentKey.date.rawValue : Date().timeIntervalSince1970,
         BookDocumentKey.title.rawValue: self.volumeInfo?.title ?? "",
         BookDocumentKey.authors.rawValue: self.volumeInfo?.authors ?? "",
         BookDocumentKey.photoURL.rawValue: self.volumeInfo?.imageLinks?.thumbnail ?? ""]
    }
    func toDocument(id: String) -> [String : Any] {
        [BookDocumentKey.id.rawValue: id,
         BookDocumentKey.title.rawValue: self.volumeInfo?.title ?? "",
         BookDocumentKey.authors.rawValue: self.volumeInfo?.authors ?? "",
         BookDocumentKey.publisher.rawValue: self.volumeInfo?.publisher ?? "",
         BookDocumentKey.publisherDate.rawValue: self.volumeInfo?.publishedDate ?? "",
         BookDocumentKey.description.rawValue: self.volumeInfo?.volumeInfoDescription ?? "",
         BookDocumentKey.isbn.rawValue: self.volumeInfo?.industryIdentifiers?.first?.identifier ?? "",
         BookDocumentKey.pageCount.rawValue: self.volumeInfo?.pageCount ?? "",
         BookDocumentKey.language.rawValue: self.volumeInfo?.language ?? "",
         BookDocumentKey.category.rawValue: self.volumeInfo?.categories ?? "",
         BookDocumentKey.rating.rawValue: self.volumeInfo?.ratingsCount ?? "",
         BookDocumentKey.photoURL.rawValue: self.volumeInfo?.imageLinks?.thumbnail ?? "",
         BookDocumentKey.retailPrice.rawValue: self.saleInfo?.retailPrice?.amount ?? "",
         BookDocumentKey.currencyCode.rawValue: self.saleInfo?.retailPrice?.currencyCode ?? ""]
    }
    init?(book document: [String: Any]) {
        let id = document[BookDocumentKey.id.rawValue] as? String
        let title = document[BookDocumentKey.title.rawValue] as? String
        let authors = document[BookDocumentKey.authors.rawValue] as? [String]
        let publisher = document[BookDocumentKey.publisher.rawValue] as? String
        let publishedDate = document[BookDocumentKey.publisherDate.rawValue] as? String
        let description = document[BookDocumentKey.description.rawValue] as? String
        let isbn = document[BookDocumentKey.isbn.rawValue] as? String
        let pageCount = document[BookDocumentKey.pageCount.rawValue] as? Int
        let category = document[BookDocumentKey.category.rawValue] as? String
        let rating = document[BookDocumentKey.rating.rawValue] as? Int
        let photoURL = document[BookDocumentKey.photoURL.rawValue] as? String
        let language = document[BookDocumentKey.language.rawValue] as? String
        let retailPrice = document[BookDocumentKey.retailPrice.rawValue] as? Double
        let currencyCode = document[BookDocumentKey.currencyCode.rawValue] as? String
        let imageLinks = ImageLinks(smallThumbnail: photoURL, thumbnail: photoURL)
        let industryIndentifier = [IndustryIdentifier(type: "", identifier: isbn)]
        let volumeInfo = VolumeInfo(title: title,
                                    authors: authors,
                                    publisher: publisher,
                                    publishedDate: publishedDate,
                                    volumeInfoDescription: description,
                                    industryIdentifiers: industryIndentifier,
                                    pageCount: pageCount,
                                    printType: "",
                                    categories: [category ?? ""],
                                    ratingsCount: rating,
                                    imageLinks: imageLinks,
                                    language: language,
                                    infoLink: "")
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: retailPrice, currencyCode: currencyCode))
        self.init(id: id, volumeInfo: volumeInfo, saleInfo: saleInfo)
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
    let smallThumbnail, thumbnail: String?
}
