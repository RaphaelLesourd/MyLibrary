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
    
    init(successTest: Bool) {
        self.successTest = successTest
    }
    
    func createBook(with book: Item, and imageData: Data, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func getBook(for bookID: String, ownerID: String, completion: @escaping (Result<Item, FirebaseError>) -> Void) {
        successTest ? completion(.success(PresenterFakeData.book)) : completion(.failure(.firebaseError(PresenterError.fail)))
    }
    
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool,
                     completion: @escaping (Result<[Item], FirebaseError>) -> Void) {
        if successTest {
            completion(.success(PresenterFakeData.books))
        } else {
            completion(.success([]))
            completion(.failure(.firebaseError(PresenterError.fail)))
        }
    }
    
    func deleteBook(book: Item, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func setStatus(to state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func removeBookListener() {}
}
