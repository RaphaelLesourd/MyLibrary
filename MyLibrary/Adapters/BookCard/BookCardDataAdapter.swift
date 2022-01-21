//
//  BookCardConfiguration.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

struct BookCardData {
    let title: String
    let authors: String
    let rating: Int
    let description: String
    let isbn: String
    let language: String
    let publisher: String
    let publishedDate: String
    let pages: String
    let price: String
    let image: String
}

protocol BookCardAdapter {
    func setCategoriesLabel(with categories: [CategoryModel]) -> NSAttributedString
    func adaptData(from book: Item) -> BookCardData
}

class BookCardDataAdapter {
    // MARK: - Properties
    private let formatter: FormatterProtocol
    
    // MARK: - Initializer
    init(formatter: FormatterProtocol) {
        self.formatter = formatter
    }
    
    private func formattedString(for categories: [CategoryModel]) -> NSAttributedString {
        let text = NSMutableAttributedString()
        categories.forEach {
            let attachment = imageStringAttachment(for: $0, size: 11)
            let imgString = NSAttributedString(attachment: attachment)
            let name = $0.name?.uppercased() ?? ""
            text.append(imgString)
            text.append(NSAttributedString(string: "\u{00a0}\(name)    "))
        }
        return text
    }
    
    private func imageStringAttachment(for category: CategoryModel, size: CGFloat) -> NSTextAttachment {
        let color = UIColor(hexString: category.color ?? "FFFFFF")
        let image = Images.ButtonIcon.selectedCategoryBadge.withTintColor(color)
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: 0, width: size, height: size)
        attachment.image = image
        return attachment
    }
}
// MARK: - BookCard presenter protocol
extension BookCardDataAdapter: BookCardAdapter {
    func setCategoriesLabel(with categories: [CategoryModel]) -> NSAttributedString {
            return formattedString(for: categories)
    }
    
    func adaptData(from book: Item) -> BookCardData {
        let language = formatter.formatCodeToName(from: book.volumeInfo?.language, type: .language).capitalized
        let publishedDate = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        let currency = book.saleInfo?.retailPrice?.currencyCode
        let value = book.saleInfo?.retailPrice?.amount
        let price = formatter.formatDoubleToPrice(with: value, currencyCode: currency)
        
        return BookCardData(title: book.volumeInfo?.title?.capitalized ?? "",
                            authors: book.volumeInfo?.authors?.joined(separator: ", ") ?? "",
                            rating: book.volumeInfo?.ratingsCount ?? 0,
                            description: book.volumeInfo?.volumeInfoDescription ?? "",
                            isbn: book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "",
                            language: language,
                            publisher: book.volumeInfo?.publisher?.capitalized ?? "",
                            publishedDate: publishedDate,
                            pages: String(book.volumeInfo?.pageCount ?? 0),
                            price: price,
                            image: book.volumeInfo?.imageLinks?.thumbnail ?? "")
    }
}
