//
//  LibraryServiceProtocol.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/12/2021.
//
import Foundation

protocol LibraryServiceProtocol {
    func createBook(with book: Item, and imageData: Data, completion: @escaping (FirebaseError?) -> Void)
    func getBook(for bookID: String, ownerID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void)
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool,
                     completion: @escaping (Result<[Item], FirebaseError>) -> Void)
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void)
    func setStatus(to state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void)
    func removeBookListener()
}
