//
//  LibraryServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class LibraryServiceMock: LibraryServiceProtocol {
    
    
    private var successTest: Bool
    
    init(_ successTest: Bool) {
        self.successTest = successTest
    }
    let books: [Item] = [Item(id: "testID",
                              bookID: "",
                              favorite: true,
                              ownerID: "",
                              recommanding: true,
                              volumeInfo: nil,
                              saleInfo: nil,
                              timestamp: 0,
                              category: nil)]
    
    func createBook(with book: Item, and imageData: Data, completion: @escaping (FirebaseError?) -> Void) {}
    
    func getBook(for bookID: String, ownerID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {}
    
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool, completion: @escaping (Result<[Item], FirebaseError>) -> Void) {
        if successTest {
            completion(.success(books))
        } else {
            
        }
    }
    
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void) {}
    
    func setStatus(to state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void) {}
    
    func removeBookListener() {}
}
