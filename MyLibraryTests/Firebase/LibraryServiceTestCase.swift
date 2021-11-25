//
//  LibraryService.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 10/11/2021.
//

import XCTest
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift
@testable import MyLibrary

class LibraryServiceTestCase: XCTestCase {
    // MARK: - Propserties
    private var sut           : LibraryService?
    private var accountService: AccountService?
    private var book          : Item?
    private var network       : Networkconnectivity?
    private let userID        = "1"
    
    private let credentials = AccountCredentials(userName: "testuser",
                                                 email: "test@test.com",
                                                 password: "Test21@",
                                                 confirmPassword: "Test21@")
    private lazy var newUser = CurrentUser(userId: "1",
                                           displayName: credentials.userName ?? "test",
                                           email: credentials.email,
                                           photoURL: "")
    private let imageData = Data()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    //    clearFirestore()
        sut            = LibraryService()
        accountService = AccountService()
        network        = Networkconnectivity.shared
        sut?.userID    = userID
        network?.status = .satisfied
    }
    
    override func tearDown() {
        super.tearDown()
        network?.stopMonitoring()
        sut            = nil
        accountService = nil
        book           = nil
        network        = nil
    }
    
    // MARK: - Private function
//    private func createAnAccount() {
//        let exp = self.expectation(description: "Waiting for async operation")
//        accountService?.createAccount(for: credentials, completion: { error in
//            XCTAssertNil(error)
//            exp.fulfill()
//        })
//        self.waitForExpectations(timeout: 10, handler: nil)
//    }
//
//    private func deleteAccount() {
//        let exp = self.expectation(description: "Waiting for async operation")
//        let docRef = sut?.usersCollectionRef
//            .document(userID)
//            .collection(CollectionDocumentKey.books.rawValue)
//        docRef?.getDocuments { (snapshot, error) in
//            XCTAssertNil(error)
//            let foundDoc = snapshot?.documents
//            foundDoc?.forEach { $0.reference.delete() }
//
//            self.sut?.usersCollectionRef.document(self.userID).delete()
//            self.accountService?.deleteAccount(with: self.credentials, completion: { error in
//                XCTAssertNil(error)
//                exp.fulfill()
//            })
//        }
//        self.waitForExpectations(timeout: 10, handler: nil)
//    }
    
    private func createBookDocument() -> Item? {
        let volumeInfo = VolumeInfo(title: "title",
                                    authors: ["author"],
                                    publisher: "publisher",
                                    publishedDate: "1900",
                                    volumeInfoDescription:"decription",
                                    industryIdentifiers: [IndustryIdentifier(identifier:"1234567890")],
                                    pageCount: 0,
                                    ratingsCount: 0,
                                    imageLinks: ImageLinks(thumbnail: "thumbnailURL"),
                                    language: "language")
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: 0.0, currencyCode: "CUR"))
        return Item(etag: "11111111111",
                    favorite: false,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: 1,
                    category: [])
    }
    
    // MARK: - Success
    func test_givenNewBook_whenAdding_thenAddedToDataBase() {
        let book = createBookDocument()
        sut?.createBook(with: book, and: imageData, completion: { error in
            XCTAssertNil(error)
        })
    }
    
    func test_givenNewBook_whenRetriving_thenDisplayDetails() {
        let book = createBookDocument()

        sut?.createBook(with: book, and: imageData, completion: { error in
            XCTAssertNil(error)

            let docRef = self.sut?.usersCollectionRef
                .document(self.userID)
                .collection(CollectionDocumentKey.books.rawValue)

            docRef?.getDocuments { (snapshot, error) in
                XCTAssertNil(error)
                if let foundDoc = snapshot?.documents,
                   let firstDocID = foundDoc.first?.documentID {

                    self.sut?.getBook(for: firstDocID, completion: { result in
                        switch result {
                        case .success(let book):
                            XCTAssertEqual(book.volumeInfo?.title, "title")
                            XCTAssertEqual(book.volumeInfo?.authors?.first, "author")
                            XCTAssertEqual(book.volumeInfo?.language, "language")
                        case .failure(let error):
                            XCTAssertNil(error)
                        }
                    })
                }
            }
        })
    }
    
    func test_givenQuery_whenRetrvingBookList_thenDisplayList() {
        let book = createBookDocument()
        let query = BookQuery(listType: .newEntry, orderedBy: .timestamp, fieldValue: nil, descending: true)
        
        sut?.createBook(with: book, and: imageData, completion: { error in
            XCTAssertNil(error)
            self.sut?.getBookList(for: query, limit: 1, forMore: false, completion: { result in
                switch result {
                case .success(let books):
                    XCTAssertEqual(books.count, 1)
                case .failure(let error):
                    XCTAssertNil(error)
                }
            })
        })
    }
    
    func test_givenBookStored_whenDeleting_thenBookNotThere() {
        let book = createBookDocument()
        let docRef = self.sut?.usersCollectionRef
            .document(self.userID)
            .collection(CollectionDocumentKey.books.rawValue)

        sut?.createBook(with: book, and: imageData, completion: { error in
            XCTAssertNil(error)
            docRef?.getDocuments { (snapshot, error) in
                XCTAssertNil(error)
                if let foundDoc = snapshot?.documents,
                   let firstDoc = foundDoc.first {
                   let book = try? firstDoc.data(as: Item.self)

                    self.sut?.deleteBook(book: book, completion: { error in
                        XCTAssertNil(error)
                    })
                }
            }
        })
    }
    
    func test_givenStoredBook_whenAddingOrRemovingFavoriteList() {
        let book = createBookDocument()
        var currentBook: Item?
        sut?.createBook(with: book, and: imageData, completion: { error in

            let docRef = self.sut?.usersCollectionRef
                .document(self.userID)
                .collection(CollectionDocumentKey.books.rawValue)

            docRef?.getDocuments { (snapshot, error) in
                XCTAssertNil(error)
                if let foundDoc = snapshot?.documents,
                   let firstDoc = foundDoc.first {
                    currentBook = try? firstDoc.data(as: Item.self)
                }

                self.sut?.setStatusTo(true, field: .favorite, for: currentBook?.etag ?? "", completion:  { error in
                    XCTAssertNil(error)

                    self.sut?.getBook(for: currentBook?.etag ?? "1", completion: { result in
                        switch result {
                        case .success(let book):
                            XCTAssertNotNil(book)
                            XCTAssertEqual(book.favorite, true)
                        case .failure(let error):
                            XCTAssertNil(error)
                        }
                    })
                })
            }
        })
    }

    // MARK: - Failure
    func test_givenNoBook_whenAdding_thenError() {
        sut?.createBook(with: nil, and: imageData, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noBookTitle.description)
        })
    }
    
    func test_givenNoNetwork_whenAdding_thenNoNetworkError() {
        network?.status = .unsatisfied
        sut?.createBook(with: nil, and: imageData, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noNetwork.description)
        })
    }
    
    func test_givenBookID_whenRetrivingNonExisting_thenError() {
        self.sut?.getBook(for: "aaaaaa", completion: { result in
            switch result {
            case .success(let book):
                XCTAssertNil(book)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, FirebaseError.nothingFound.description)
            }
        })
    }
    
    func test_givenQuery_whenRetrvingBookListNoNetworkConnection_thenNetworkError() {
        let query = BookQuery(listType: .categories, orderedBy: .category, fieldValue: "somefield", descending: true)
    
        network?.status = .unsatisfied
        sut?.getBookList(for: query, limit: 1, forMore: false, completion: { result in
            switch result {
            case .success(let books):
                XCTAssertEqual(books.count, 0)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, FirebaseError.noNetwork.description)
            }
        })
    }
    
    
    func test_givenBadQuery_whenRetrvingBookList_thenNothingFoundError() {
        let query = BookQuery(listType: .categories, orderedBy: .category, fieldValue: "", descending: true)
        
        sut?.getBookList(for: query, limit: 1, forMore: false, completion: { result in
            switch result {
            case .success(let books):
                XCTAssertEqual(books.count, 0)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
    }
    
    func test_givenNoBookStored_whenDeleting_thenNoBookError() {
        let book = createBookDocument()
        sut?.deleteBook(book: book, completion: { error in
            XCTAssertNotNil(error)
      //      XCTAssertEqual(error?.description, FirebaseError.firebaseError(error?.description))
        })
    }
    
    func test_givenNilBook_whenDeleting_thenNoBookError() {
        sut?.deleteBook(book: nil, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.nothingFound.description)
        })
    }

    func test_givenNoStoredBook_whenAddingOrRemovingFavoriteList_thenError() {
        sut?.setStatusTo(true, field: .favorite, for: nil, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.nothingFound.description)
        })
    }
    
    func test_givenStoredBook_whenAddingOrRemovingFavoriteList_thenError() {
        sut?.setStatusTo(true, field: .favorite, for: nil, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.nothingFound.description)
        })
    }
}
