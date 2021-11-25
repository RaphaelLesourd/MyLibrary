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
    // MARK: - Properties
    private var sut       : RecommandationServiceProtocol?
    private var book      : Item?
    private let imageData = Data()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = RecommandationService()
    }
    
    override func tearDown() {
        super.tearDown()
        sut            = nil
        book           = nil
       // clearFirestore()
    }
    
    // MARK: - Private function
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
}
