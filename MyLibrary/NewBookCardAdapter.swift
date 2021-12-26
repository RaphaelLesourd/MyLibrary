//
//  NewBookCardAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

struct NewBookData {
    let title: String
    let author: String
    let rating: Int
    let publisherName: String
    let publishedDate: String
    let pages: String
    let isbn: String
    let price: String
    let image: UIImage
}

protocol NewBookAdapter {
    func getNewBookData(for book: Item, completion: @escaping(NewBookData) -> Void)
}

class NewBookDataAdapter {
    private let imageRetriever: ImageRetriever
    private let converter: ConverterProtocol
    private let formatter: FormatterProtocol
    
    init(imageRetriever: ImageRetriever,
         converter: ConverterProtocol,
         formatter: FormatterProtocol) {
        self.imageRetriever = imageRetriever
        self.converter = converter
        self.formatter = formatter
    }
}
extension NewBookDataAdapter: NewBookAdapter {
   
    func getNewBookData(for book: Item, completion: @escaping (NewBookData) -> Void) {
        let title = book.volumeInfo?.title?.capitalized ?? ""
        let authors = converter.convertArrayToString(book.volumeInfo?.authors)
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
