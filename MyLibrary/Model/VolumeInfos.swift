//
//  VolumeInfos.swift
//  MyLibrary
//
//  Created by Birkyboy on 06/11/2021.
//

import Foundation

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
