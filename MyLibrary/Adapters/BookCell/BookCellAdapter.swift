//
//  BookCellConfigure.swift
//  MyLibrary
//
//  Created by Birkyboy on 26/12/2021.
//

struct BookCellData {
    let title: String
    let author: String
    let description: String
    let image: String
}

protocol BookCellAdapter {
    func setBookData(for book: Item) -> BookCellData
}
extension BookCellAdapter {
    func setBookData(for book: Item) -> BookCellData {
        let title = book.volumeInfo?.title?.capitalized ?? ""
        let authors = book.volumeInfo?.authors?.joined(separator: ", ") ?? ""
        let description = book.volumeInfo?.volumeInfoDescription ?? ""
        return BookCellData(title: title,
                            author: authors,
                            description: description,
                            image: book.volumeInfo?.imageLinks?.thumbnail ?? "")
    }
}
