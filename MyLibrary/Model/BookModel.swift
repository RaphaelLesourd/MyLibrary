//
//  BookModel.swift
//  MyLibrary
//
//  Created by Birkyboy on 29/10/2021.
//

import Foundation

// MARK: - BookModel
struct BookModel: Decodable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Decodable {
    let kind: String?
    let volumeInfo: VolumeInfo?
    let saleInfo: SaleInfo?
}

// MARK: - SaleInfo
struct SaleInfo: Decodable {
    let country: String?
}

// MARK: - VolumeInfo
struct VolumeInfo: Decodable {
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

// MARK: - IndustryIdentifier
struct IndustryIdentifier: Decodable {
    let type, identifier: String?
}

// MARK: - ImageLinks
struct ImageLinks: Decodable {
    let thumbnail: String?
}
