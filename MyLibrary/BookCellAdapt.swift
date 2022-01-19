//
//  BookCellConfiguration.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

import UIKit

class BookCellAdapt {
    // MARK: - Properties
    private var imageRetriever: ImageRetriever
    
    // MARK: - Initializer
    init(imageRetriever: ImageRetriever) {
        self.imageRetriever = imageRetriever
    }
}
// MARK: Cell presenter 
extension BookCellAdapt: BookCellAdapter {
    
    func setBookData(for book: Item, completion: @escaping (BookCellData) -> Void) {
        let title = book.volumeInfo?.title?.capitalized ?? ""
        let authors = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
        let description = book.volumeInfo?.volumeInfoDescription ?? ""
        
        imageRetriever.getImage(for: book.volumeInfo?.imageLinks?.thumbnail) { image in
            let bookData = BookCellData(title: title,
                                        author: authors,
                                        description: description,
                                        image: image)
            completion(bookData)
        }
    }
}
