//
//  BookCardAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

struct BookCardData {
    let title: String
    let author: String
    let rating: Int
    let description: String
    let publisherName: String
    let publishedDate: String
    let pages: String
    let isbn: String
    let price: String
    let language: String
    let image: UIImage
}

protocol BookCardAdapter {
    func getBookCardData(for book: Item, completion: @escaping(BookCardData) -> Void)
    func getBookCategories(for categoryIds: [String], bookOwnerID: String,completion: @escaping (String) -> Void)
}

class BookCardDataAdapter {
    private let imageRetriever: ImageRetriever
    private let converter: ConverterProtocol
    private let formatter: FormatterProtocol
    private let categoryService: CategoryServiceProtocol
    
    init(imageRetriever: ImageRetriever,
         converter: ConverterProtocol,
         formatter: FormatterProtocol, categoryService: CategoryService) {
        self.imageRetriever = imageRetriever
        self.converter = converter
        self.formatter = formatter
        self.categoryService = categoryService
    }
}
extension BookCardDataAdapter: BookCardAdapter {
    
    func getBookCardData(for book: Item, completion: @escaping (BookCardData) -> Void) {
        let title = book.volumeInfo?.title?.capitalized
        let authors = converter.convertArrayToString(book.volumeInfo?.authors)
        let rating = book.volumeInfo?.ratingsCount ?? 0
        let publisherName = book.volumeInfo?.publisher?.capitalized
        let publishedDate = book.volumeInfo?.publishedDate
        let currency = book.saleInfo?.retailPrice?.currencyCode
        let value = book.saleInfo?.retailPrice?.amount
        let price = formatter.formatDoubleToPrice(with: value,
                                                  currencyCode: currency)
        let language = formatter.formatCodeToName(from: book.volumeInfo?.language,
                                                  type: .language).capitalized
        let isbn = Text.Book.isbn + (book.volumeInfo?.industryIdentifiers?.first?.identifier ?? "")
        let pages = String(book.volumeInfo?.pageCount ?? 0)

        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail, completion: { image in
            let bookData = BookCardData(title: title ?? "",
                                        author: authors,
                                        rating: rating,
                                        description: book.volumeInfo?.volumeInfoDescription ?? "",
                                        publisherName: publisherName ?? "",
                                        publishedDate: publishedDate ?? "",
                                        pages: pages,
                                        isbn: isbn,
                                        price: price,
                                        language: language,
                                        image: image)
            completion(bookData)
        })
    }
    
    func getBookCategories(for categoryIds: [String], bookOwnerID: String,completion: @escaping (String) -> Void) {
     
        categoryService.getCategoryNameList(for: categoryIds, bookOwnerID: bookOwnerID) { [weak self] categoryNames in
            let categories = self?.converter.convertArrayToString(categoryNames)
            completion(categories ?? "")
        }
    }
}
