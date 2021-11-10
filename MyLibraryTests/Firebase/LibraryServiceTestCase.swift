//
//  LibraryService.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 10/11/2021.
//

import XCTest
@testable import MyLibrary

class LibraryServiceTestCase: XCTestCase {
    // MARK: - Propserties
    private var sut: LibraryService?
    private var accountService: AccountService?
    private var book: Item?
    private let userID = "1"
    private let credentials = AccountCredentials(userName: "testuser",
                                                 email: "test@test.com",
                                                 password: "Test21@",
                                                 confirmPassword: "Test21@")
    private lazy var newUser = CurrentUser(userId: "1",
                                           displayName: credentials.userName ?? "test",
                                           email: credentials.email,
                                           photoURL: "")
    
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = LibraryService()
        accountService = AccountService()
        deleteAccount()
        sut?.userID = userID
        createAnAccount()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        accountService = nil
        book = nil
    }
    
    // MARK: - Private function
    private func createAnAccount() {
        accountService?.createAccount(for: credentials, completion: { error in
            if let error = error {
                print(error.description)
            }
        })
    }
    
    private func deleteAccount() {
        accountService?.deleteAccount(with: credentials, completion: { error in
            if let error = error {
                print(error.description)
            }
        })
    }
    
    
    private func createBookDocument() -> Item? {
        let volumeInfo = VolumeInfo(title: "title",
                                    authors: ["author"],
                                    publisher: "publisher",
                                    publishedDate: "1900",
                                    volumeInfoDescription:"decription",
                                    industryIdentifiers: [IndustryIdentifier(identifier:"1234567890")],
                                    pageCount: 0,
                                    categories: ["category"],
                                    ratingsCount: 0,
                                    imageLinks: ImageLinks(smallThumbnail: "smallThumbnailURL",
                                                           thumbnail: "thumbnailURL"),
                                    language: "language")
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: 0.0, currencyCode: "CUR"))
        return Item(etag: "A8EDD853-D944-4FC6-9C2C-1E88B08421DA",
                    favorite: false,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: 1)
    }
    
    // MARK: - Success
    func test_givenNewBook_whenAdding_thenAddedToDataBase() {
        let book = createBookDocument()
        let exp = self.expectation(description: "Waiting for async operation")
        sut?.createBook(with: book, completion: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenNewBook_whenRetriving_thenDisplayDetails() {
        let book = createBookDocument()
        var id = ""
        let exp = self.expectation(description: "Waiting for async operation")
        sut?.createBook(with: book, completion: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
        
        let exp2 = self.expectation(description: "Waiting for async operation")
        let docRef = sut?.usersCollectionRef
            .document(userID)
            .collection(CollectionDocumentKey.books.rawValue)
        docRef?.getDocuments { (snapshot, error) in
              XCTAssertNil(error)
            if let foundDoc = snapshot?.documents,
               let firstDocID = foundDoc.first?.documentID {
                id = firstDocID
            }
            exp2.fulfill()
        }
        self.waitForExpectations(timeout: 10, handler: nil)
        
        let exp3 = self.expectation(description: "Waiting for async operation")
        print("IDIDIDID: \(id)")
        self.sut?.retrieveBook(for: id, completion: { result in
            switch result {
            case .success(let book):
                XCTAssertNotNil(book)
                XCTAssertEqual(book.volumeInfo?.title, "title")
            case .failure(let error):
                XCTAssertNil(error)
            }
            exp3.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Error
    func test_givenNoBook_whenAdding_thenError() {
        let exp = self.expectation(description: "Waiting for async operation")
        sut?.createBook(with: nil, completion: { error in
            XCTAssertNotNil(error)
        })
        exp.fulfill()
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
}
