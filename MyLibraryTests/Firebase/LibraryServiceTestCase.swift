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
    private var sut: LibraryService!
    private var userService: UserService!
    private let imageData = Data()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = LibraryService()
        userService = UserService()
        Networkconnectivity.shared.status = .satisfied
        createUserInDatabase()
        createBookInDataBase()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        clearFirestore()
    }
    
    private func createUserInDatabase() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        userService.createUserInDatabase(for: FakeData.user, completion: { error in
            XCTAssertNil(error)
            self.userService.userID = FakeData.user.userID
            self.sut.userID = FakeData.user.userID
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
    }
    
    private func createBookInDataBase() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        self.sut.createBook(with: FakeData.book, and: self.imageData, completion: { error in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Success
    func test_givenNewBook_whenRetriving_thenDisplayDetails() {
        createBookInDataBase()
        let expectation = XCTestExpectation(description: "Waiting for async operation")
            self.sut.getBook(for: "11111111", ownerID: "user1", completion: { result in
                switch result {
                case .success(let book):
                    XCTAssertEqual(book.volumeInfo?.title, FakeData.book.volumeInfo?.title)
                    XCTAssertEqual(book.volumeInfo?.authors?.first, FakeData.book.volumeInfo?.authors?.first)
                    XCTAssertEqual(book.volumeInfo?.language, FakeData.book.volumeInfo?.language)
                case .failure(let error):
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenQuery_whenRetrvingBookList_thenDisplayList() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        let query = BookQuery(listType: .newEntry, orderedBy: .timestamp, fieldValue: nil, descending: true)
            self.sut?.getBookList(for: query, limit: 1, forMore: false, completion: { result in
                switch result {
                case .success(let books):
                    XCTAssertEqual(books.first?.volumeInfo?.title, "title")
                case .failure(let error):
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenBookStored_whenDeleting_thenBookNotThere() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
            self.sut.deleteBook(book: FakeData.book, completion: { error in
                XCTAssertNil(error)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenStoredBook_whenAddingOrRemovingFavoriteList() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
    
            self.sut.setStatus(to: true, field: .favorite, for: FakeData.book.bookID, completion:  { error in
                XCTAssertNil(error)
                self.sut.getBook(for: "11111111", ownerID: "user1", completion: { result in
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
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Failure
    func test_givenBookID_whenRetrivingNonExisting_thenError() {
        guard let ownerID = FakeData.book.ownerID else { return }
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        
        self.sut.getBook(for: "aaaaaa", ownerID: ownerID, completion: { result in
            switch result {
            case .success(let book):
                XCTAssertNil(book)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func test_givenBadQuery_whenRetrvingBookList_thenNothingFoundError() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        let query = BookQuery(listType: .categories, orderedBy: .category, fieldValue: "", descending: true)
        self.sut.getBookList(for: query, limit: 1, forMore: false, completion: { result in
            switch result {
            case .success(let books):
                XCTAssertEqual(books, [])
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenBookWithNotitle_whenCreating_thenNoTitleError() {
        let volumeInfo = VolumeInfo(title: "",
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
        let book = ItemDTO(id: "noTitle",
                    bookID: "11111111",
                    favorite: true,
                    ownerID: "AAAAAA",
                    recommanding: true,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: 0,
                    category: [])
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        self.sut.createBook(with: book, and: self.imageData, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noBookTitle.description)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenBook_whenCreatingWithNoNetwork_thenNetWorkError() {
        Networkconnectivity.shared.status = .unsatisfied
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        self.sut.createBook(with: FakeData.book, and: self.imageData, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noNetwork.description)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
}
