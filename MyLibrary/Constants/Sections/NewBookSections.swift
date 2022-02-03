//
//  NewBookSections.swift
//  MyLibrary
//
//  Created by Birkyboy on 29/01/2022.
//

/// NewBook tableView Sections
enum NewBookSections: CaseIterable {
    case coverPicture
    case title
    case categories
    case publisher
    case details
    case language
    case rating
    case price
    case saveButton
    case deleteButton

    var headerTitle: String {
        switch self {
        case .coverPicture, .title, .saveButton, .deleteButton:
            return ""
        case .categories:
            return Text.SectionTitle.newBookCategoriesHeader
        case .publisher:
            return Text.SectionTitle.newBookPublishingHeader
        case .details:
            return Text.SectionTitle.newBookDetailsHeader
        case .language:
            return Text.Book.bookLanguage
        case .rating:
            return Text.SectionTitle.newBookRatingHeader
        case .price:
            return Text.SectionTitle.newBookPriceHeader
        }
    }
}
