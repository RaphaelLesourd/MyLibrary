//
//  RecommandServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 22/11/2021.
//

@testable import MyLibrary
import XCTest

class RecommandServiceTestCase: XCTestCase {
    // MARK: - Properties
    private var sut: RecommendationServiceProtocol?
    private var book: Item!
    private let imageData = Data()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut  = RecommandationService()
        book = createBookDocumentData()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        book = nil
        clearFirestore()
    }
    
    // MARK: - Success
    func test_givenBook_whenRecommanding_thenAddedToRecommandation() {
        let exp = expectation(description: "Wait for async")
        guard let book = book else { return }
        sut?.addToRecommandation(for: book, completion: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenRecommendedBook_whenNotRecommanded_thenRemovedFromRecommandation() {
        let exp = expectation(description: "Wait for async")
        guard let book = book else { return }
        sut?.addToRecommandation(for: book, completion: { error in
            XCTAssertNil(error)
            self.sut?.removeFromRecommandation(for: book, completion: { error in
                XCTAssertNil(error)
            })
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
