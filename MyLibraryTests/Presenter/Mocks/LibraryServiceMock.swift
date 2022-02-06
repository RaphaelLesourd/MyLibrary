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
    
    func createBook(with book: ItemDTO, and imageData: Data, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func getBook(for bookID: String, ownerID: String, completion: @escaping (Result<ItemDTO, FirebaseError>) -> Void) {
        successTest ? completion(.success(FakeData.book)) : completion(.failure(.firebaseError(FakeData.PresenterError.fail)))
    }
    
    func getBookList(for query: BookQuery, limit: Int, forMore: Bool,
                     completion: @escaping (Result<[ItemDTO], FirebaseError>) -> Void) {
        if successTest {
            completion(.success(FakeData.books))
        } else {
            completion(.success([]))
            completion(.failure(.firebaseError(FakeData.PresenterError.fail)))
        }
    }
    
    func deleteBook(book: ItemDTO, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func setStatus(to state: Bool, field: DocumentKey, for id: String?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func removeBookListener() {}
}
