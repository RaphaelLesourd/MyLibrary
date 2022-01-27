//
//  LibraryPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol LibraryPresenting {
    var view: LibraryPresenterView? { get set }
    var endOfList: Bool { get set }
    var bookList: [Item] { get set }
    func getBooks(with query: BookQuery, nextPage: Bool)
    func makeBookCellRepresentable(for book: Item) -> BookCellRepresentable
}
