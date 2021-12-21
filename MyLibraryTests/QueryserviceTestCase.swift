//
//  QueryServiceUnitTest.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/12/2021.
//

import XCTest
@testable import MyLibrary

class QueryserviceTestCase: XCTestCase {

    private var sut: QueryServiceProtocol?
    private let currentQuery = BookQuery(listType: .recommanding, orderedBy: .timestamp, fieldValue: "", descending: true)
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = QueryService()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Success tests
    func test_givenBookQuery_whenChangingOrder_thenReturnNewQuery() {
        sut?.currentQuery = currentQuery
        let newQuery = sut?.getQuery(with: .rating)
        XCTAssertEqual(newQuery?.orderedBy, .rating)
    }
    
    func test_givenBookQuery_whenChangingOrderToAuthorOrTitle_thenReturnNewQueryWithDescendingOrderFalse() {
        sut?.currentQuery = currentQuery
        let newQuery = sut?.getQuery(with: .title)
        XCTAssertEqual(newQuery?.descending, false)
    }
    
    func test_givenBookQuery_whenChangingOrderNotAuthorOrTitle_thenReturnNewQueryWithDescendingOrderTrue() {
        sut?.currentQuery = currentQuery
        let newQuery = sut?.getQuery(with: .rating)
        XCTAssertEqual(newQuery?.descending, true)
    }
    
    func test_givenBookQuery_whenChangingWithNil_thenReturnNewQueryOrderedByTimestamp() {
        sut?.currentQuery = currentQuery
        let newQuery = sut?.getQuery(with: nil)
        XCTAssertEqual(newQuery?.orderedBy, .timestamp)
    }
}
