//
//  RecommandServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 22/11/2021.
//

import XCTest
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift
@testable import MyLibrary

class RecommandServiceTestCase: XCTestCase {
    // MARK: - Propserties
    private var sut           : RecommandationServiceProtocol?
    private var accountService: AccountService?
    private var userService   : UserService?
    private var book          : Item?
    private var userID        = "1"
    
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
  //      clearFirestore()
        sut            = RecommandationService()
        accountService = AccountService()
        userService    = UserService()
    }
    
    override func tearDown() {
        super.tearDown()
        sut            = nil
        accountService = nil
        userService    = nil
        book           = nil
        
    }
    
    // MARK: - Private function
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
    func test_givenBook_whenRecommanding_thenAddedToRecommandation() {
        let book = createBookDocument()
        sut?.addToRecommandation(for: book, completion: { error in
            XCTAssertNil(error)
        })
    }
    
    func test_givenRecommendedBook_whenNotRecommanded_thenRemovedFromRecommandation() {
        let book = createBookDocument()
        sut?.addToRecommandation(for: book, completion: { error in
            XCTAssertNil(error)
            self.sut?.removeFromRecommandation(for: book, completion: { error in
                XCTAssertNil(error)
            })
        })
    }
    
    // MARK: - Failure
    func test_givenNilBook_whenRecommanding_thenAddedToRecommandation() {
        sut?.addToRecommandation(for: nil, completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.nothingFound.description)
        })
    }
    
    func test_givenRecommendedBook_whenNotRecommandingNilBook_thenError() {
        let book = createBookDocument()
        sut?.addToRecommandation(for: book, completion: { error in
            XCTAssertNil(error)
            self.sut?.removeFromRecommandation(for: nil, completion: { error in
                XCTAssertNotNil(error)
            })
        })
    }
}
