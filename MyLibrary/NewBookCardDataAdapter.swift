//
//  NewBookCardAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class NewBookDataAdapter {
    
    // MARK: - Properties
    private let imageRetriever: ImageRetriever
    private let converter: ConverterProtocol
    private let formatter: FormatterProtocol
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever,
         converter: ConverterProtocol,
         formatter: FormatterProtocol) {
        self.imageRetriever = imageRetriever
        self.converter = converter
        self.formatter = formatter
    }
}
// MARK: - NewBook adapter protocol
extension NewBookDataAdapter: NewBookAdapter {
   
    func getNewBookData(for book: Item, completion: @escaping (NewBookData) -> Void) {
        let title = book.volumeInfo?.title?.capitalized ?? ""
        let authors = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
        let rating = book.volumeInfo?.ratingsCount ?? 0
        let publisherName = book.volumeInfo?.publisher?.capitalized ?? ""
        let publishedDate = formatter.formatDateToYearString(for: book.volumeInfo?.publishedDate)
        let price = String(book.saleInfo?.retailPrice?.amount ?? 0)
        let isbn = book.volumeInfo?.industryIdentifiers?.first?.identifier ?? ""
        let pages = String(book.volumeInfo?.pageCount ?? 0)

        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail, completion: { image in
            let bookData = NewBookData(title: title,
                                       author: authors,
                                       rating: rating,
                                       publisherName: publisherName,
                                       publishedDate: publishedDate,
                                       pages: pages,
                                       isbn: isbn,
                                       price: price,
                                       image: image)
            completion(bookData)
        })
    }
}
