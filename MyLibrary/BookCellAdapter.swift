//
//  BookCellAdapter.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

struct BookCellData {
    let title: String
    let author: String
    let description: String
    let image: UIImage
}

protocol BookCellAdapter {
    func getBookData(for book: Item, completion: @escaping (BookCellData) -> Void)
}

class BookCellDataAdapter {
    private var imageRetriever: ImageRetriever
    private var converter: ConverterProtocol
    
    init(imageRetriever: ImageRetriever,
         converter: ConverterProtocol) {
        self.imageRetriever = imageRetriever
        self.converter = converter
    }
}
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
