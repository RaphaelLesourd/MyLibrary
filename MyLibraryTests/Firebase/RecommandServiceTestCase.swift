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
    private let imageData = Data()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut  = RecommandationService()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        clearFirestore()
    }
    
    // MARK: - Success
    func test_givenBook_whenRecommanding_thenAddedToRecommandation() {
        let exp = expectation(description: "Wait for async")
        sut?.addToRecommandation(for: FakeData.book, completion: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenRecommendedBook_whenNotRecommanded_thenRemovedFromRecommandation() {
        let exp = expectation(description: "Wait for async")
        sut?.addToRecommandation(for: FakeData.book, completion: { error in
            XCTAssertNil(error)
            self.sut?.removeFromRecommandation(for: FakeData.book, completion: { error in
                XCTAssertNil(error)
            })
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}
