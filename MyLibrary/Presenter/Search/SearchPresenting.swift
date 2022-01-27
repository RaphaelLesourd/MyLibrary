//
//  SearchPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol SearchPresenting {
    var view: SearchPresenterView? { get set }
    var searchedBooks: [Item] { get set }
    var noMoreBooks: Bool? { get set }
    var searchType: SearchType? { get set }
    var currentSearchKeywords: String { get set }
    func getBooks(with keywords: String, fromIndex: Int)
    func makeBookCellRepresentable(for book: Item) -> BookCellRepresentable
    func refreshData()
}
