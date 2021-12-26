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
        
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { [weak self] image in
            let bookData =  BookCellData(title: book.volumeInfo?.title?.capitalized ?? "",
                                         author: self?.converter.convertArrayToString(book.volumeInfo?.authors) ?? "",
                                         description: book.volumeInfo?.volumeInfoDescription ?? "",
                                         image: image)
            completion(bookData)
        }
    }
}
