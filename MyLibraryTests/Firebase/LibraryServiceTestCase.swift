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
    private var newUser    : CurrentUser!
    private let imageData  = Data()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut         = LibraryService()
        userService = UserService()
        newUser     = createUser()
        sut?.userID = newUser.userId
        book        = createBookDocument()
        Networkconnectivity.shared.status = .satisfied
    }
    
    override func tearDown() {
        super.tearDown()
        newUser = nil
        sut     = nil
        book    = nil
        clearFirestore()
    }
 
    // MARK: - Success
    func test_givenNewBook_whenAdding_thenAddedToDataBase() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.createBook(with: self.book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenNewBook_whenRetriving_thenDisplayDetails() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
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
                    expectation.fulfill()
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func test_givenQuery_whenRetrvingBookList_thenDisplayList() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
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
                    expectation.fulfill()
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenBookStored_whenDeleting_thenBookNotThere() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.createBook(with: self.book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                self.sut?.deleteBook(book: self.book, completion: { error in
                    XCTAssertNil(error)
                    expectation.fulfill()
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenStoredBook_whenAddingOrRemovingFavoriteList() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
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
                        expectation.fulfill()
                    })
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Failure
    func test_givenBookID_whenRetrivingNonExisting_thenError() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.getBook(for: "aaaaaa", completion: { result in
                switch result {
                case .success(let book):
                    XCTAssertNil(book)
                case .failure(let error):
                    XCTAssertNotNil(error)
                }
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func test_givenBadQuery_whenRetrvingBookList_thenNothingFoundError() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
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
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
}
