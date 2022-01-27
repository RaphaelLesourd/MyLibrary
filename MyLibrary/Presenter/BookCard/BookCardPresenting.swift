//
//  BookCardPresenting.swift
//  MyLibrary
//
//  Created by Birkyboy on 27/01/2022.
//

protocol BookCardPresenting {
    var view: BookCardPresenterView? { get set }
    var book: Item? { get set }
    func deleteBook()
    func updateBook()
    func recommendBook(_ recommend: Bool)
    func fetchCategoryNames()
    func formatCategoryList(with categories: [CategoryModel])
    func convertToBookRepresentable(from book: Item)
    func updateStatus(state: Bool, documentKey: DocumentKey)
}
