//
//  BookCellConfigure.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

protocol BookCellMapper {
    func makeBookCellUI(for book: ItemDTO) -> BookCellUI
}

extension BookCellMapper {
    func makeBookCellUI(for book: ItemDTO) -> BookCellUI {
        let title = book.volumeInfo?.title?.capitalized
        let authors = book.volumeInfo?.authors?.joined(separator: ", ")
        let description = book.volumeInfo?.volumeInfoDescription
        return BookCellUI(title: title,
                          author: authors,
                          description: description,
                          image: book.volumeInfo?.imageLinks?.thumbnail)
    }
}
