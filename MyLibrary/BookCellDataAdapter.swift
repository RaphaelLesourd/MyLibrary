//
//  BookCellAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class BookCellDataAdapter {
    // MARK: - Properties
    private var imageRetriever: ImageRetriever
    private var converter: ConverterProtocol
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever,
         converter: ConverterProtocol) {
        self.imageRetriever = imageRetriever
        self.converter = converter
    }
}
// MARK: BookCell Adapter protocol
extension BookCellDataAdapter: BookCellAdapter {
    
    func getBookData(for book: Item, completion: @escaping (BookCellData) -> Void) {
        let title = book.volumeInfo?.title?.capitalized ?? ""
        let authors = converter.convertArrayToString(book.volumeInfo?.authors)
        let description = book.volumeInfo?.volumeInfoDescription ?? ""
        
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { image in
            let bookData =  BookCellData(title: title,
                                         author: authors,
                                         description: description,
                                         image: image)
            completion(bookData)
        }
    }
}