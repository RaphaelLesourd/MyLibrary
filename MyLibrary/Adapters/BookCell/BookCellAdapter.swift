//
//  BookCellConfigure.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol BookCellAdapter {
    func makeBookCellRepresentable(for book: Item) -> BookCellRepresentable
}

extension BookCellAdapter {
    func makeBookCellRepresentable(for book: Item) -> BookCellRepresentable {
        let title = book.volumeInfo?.title?.capitalized ?? ""
        let authors = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
        let description = book.volumeInfo?.volumeInfoDescription ?? ""
        return BookCellRepresentable(title: title,
                                     author: authors,
                                     description: description,
                                     image: book.volumeInfo?.imageLinks?.thumbnail ?? "")
    }
}
