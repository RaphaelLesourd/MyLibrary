//
//  LibraryService.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 10/11/2021.
//

@testable import MyLibrary
import XCTest

class LibraryServiceTestCase: XCTestCase {
    // MARK: - Properties
    private var sut        : LibraryService?
    private var userService: UserService?
    private var book       : Item!
    private let userID     = "qRz7UZqvkIOOMgxGdD3"
    private let imageData  = Data()
    private var exp        : XCTestExpectation?

    private let credentials = AccountCredentials(userName: "testuser",
                                                 email: "testuser@test.com",
                                                 password: "Test21@",
                                                 confirmPassword: "Test21@")
    private lazy var newUser = CurrentUser(userId: "qRz7UZqvkIOOMgxGdD3",
                                           displayName: credentials.userName ?? "test",
                                           email: credentials.email,
                                           photoURL: "")
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        exp         = expectation(description: "Waiting for async operation")
        sut         = LibraryService()
        userService = UserService()
        sut?.userID = userID
        book        = createBookDocument()
        Networkconnectivity.shared.status = .satisfied
    }
    
    override func tearDown() {
        super.tearDown()
        sut     = nil
        book    = nil
        exp     = nil
        clearFirestore()
    }

    // MARK: - Private functions
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
        return Item(bookID: "11111111",
                    favorite: false,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: 1,
                    category: [])
    }
    
    // MARK: - Success
    func test_givenNewBook_whenAdding_thenAddedToDataBase() {
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.createBook(with: self.book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                self.exp?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenNewBook_whenRetriving_thenDisplayDetails() {
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.createBook(with: self.book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                self.sut?.getBook(for: "11111111", completion: { result in
                    switch result {
                    case .success(let book):
                        XCTAssertEqual(book.volumeInfo?.title, "title")
                        XCTAssertEqual(book.volumeInfo?.authors?.first, "author")
                        XCTAssertEqual(book.volumeInfo?.language, "language")
                    case .failure(let error):
                        XCTAssertNil(error)
                    }
                    self.exp?.fulfill()
                })
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
        
    }

    func test_givenQuery_whenRetrvingBookList_thenDisplayList() {
        let query = BookQuery(listType: .newEntry, orderedBy: .timestamp, fieldValue: nil, descending: true)
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.createBook(with: self.book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                self.sut?.getBookList(for: query, limit: 1, forMore: false, completion: { result in
                    switch result {
                    case .success(let books):
                        XCTAssertEqual(books.first?.volumeInfo?.title, "title")
                    case .failure(let error):
                        XCTAssertNil(error)
                    }
                    self.exp?.fulfill()
                })
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    func test_givenBookStored_whenDeleting_thenBookNotThere() {
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.createBook(with: self.book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                self.sut?.deleteBook(book: self.book, completion: { error in
                    XCTAssertNil(error)
                    self.exp?.fulfill()
                })
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenStoredBook_whenAddingOrRemovingFavoriteList() {
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.createBook(with: self.book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                self.sut?.setStatusTo(true, field: .favorite, for: self.book.bookID, completion:  { error in
                    XCTAssertNil(error)
                    self.sut?.getBook(for: self.book.bookID ?? "", completion: { result in
                        switch result {
                        case .success(let book):
                            XCTAssertNotNil(book)
                            XCTAssertEqual(book.favorite, true)
                        case .failure(let error):
                            XCTAssertNil(error)
                        }
                        self.exp?.fulfill()
                    })
                })
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }

   // MARK: - Failure
        func test_givenBookID_whenRetrivingNonExisting_thenError() {
            userService?.createUserInDatabase(for: newUser, completion: { error in
                XCTAssertNil(error)
                self.sut?.getBook(for: "aaaaaa", completion: { result in
                    switch result {
                    case .success(let book):
                        XCTAssertNil(book)
                    case .failure(let error):
                        XCTAssertNotNil(error)
                    }
                    self.exp?.fulfill()
                })
            })
            self.waitForExpectations(timeout: 10, handler: nil)
    }


    func test_givenBadQuery_whenRetrvingBookList_thenNothingFoundError() {
        let query = BookQuery(listType: .categories, orderedBy: .category, fieldValue: "", descending: true)
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.getBookList(for: query, limit: 1, forMore: false, completion: { result in
                switch result {
                case .success(let books):
                    XCTAssertEqual(books, [])
                case .failure(let error):
                    XCTAssertNil(error)
                }
                self.exp?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
