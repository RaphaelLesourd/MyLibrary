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
    // MARK: - Properties
    private var sut           : LibraryService?
    private var accountService: AccountService?
    private var book          : Item!
    private var network       : Networkconnectivity?
    private var storageService: ImageStorageService?
    private let userID        = "bLD1HPeHhqRz7UZqvkIOOMgxGdD3"
    private let imageData     = Data()

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        //clearFirestore()
        sut             = LibraryService()
        accountService  = AccountService()
        storageService  = ImageStorageService()
        network         = Networkconnectivity.shared
        sut?.userID     = userID
        storageService?.userID = userID
        network?.startMonitoring()
        network?.status = .satisfied
        book            = createBookDocument()
    }
    
    override func tearDown() {
        super.tearDown()
        network?.stopMonitoring()
        sut            = nil
        accountService = nil
        network        = nil
        book           = nil
    }

    private func createBookDocument() -> Item {
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
        return Item(etag: "bLD1HPeHhqRz7UZqvkIOOMgxGdD3",
                    favorite: false,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: 1,
                    category: [])
    }
    
    // MARK: - Success
    func test_givenNewBook_whenAdding_thenAddedToDataBase() {
        network?.status = .satisfied
        sut?.createBook(with: book, and: imageData, completion: { error in
            XCTAssertNil(error)
        })
    }
    
    func test_givenNewBook_whenRetriving_thenDisplayDetails() {
        network?.status = .satisfied
        sut?.createBook(with: book, and: imageData, completion: { error in
            XCTAssertNil(error)
            self.sut?.getBook(for: "bLD1HPeHhqRz7UZqvkIOOMgxGdD3", completion: { result in
                switch result {
                case .success(let book):
                    XCTAssertEqual(book.volumeInfo?.title, "title")
                    XCTAssertEqual(book.volumeInfo?.authors?.first, "author")
                    XCTAssertEqual(book.volumeInfo?.language, "language")
                case .failure(let error):
                    XCTAssertNil(error)
                }
            })
        })
    }
    
    func test_givenQuery_whenRetrvingBookList_thenDisplayList() {
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

                    self.sut?.deleteBook(book: book!, completion: { error in
                        XCTAssertNil(error)
                    })
                }
            }
        })
    }
    
    func test_givenStoredBook_whenAddingOrRemovingFavoriteList() {
        var currentBook: Item?
        sut?.createBook(with: book, and: imageData, completion: { error in
            XCTAssertNil(error)

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
    func test_givenBookID_whenRetrivingNonExisting_thenError() {
        self.sut?.getBook(for: "aaaaaa", completion: { result in
            switch result {
            case .success(let book):
                XCTAssertNil(book)
            case .failure(let error):
                XCTAssertNotNil(error)
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
}
