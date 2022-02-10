//
//  CategoryPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 19/01/2022.
//

import XCTest
@testable import MyLibrary

class SearchPresenterTestCase: XCTestCase {

    private var sut: SearchPresenter!
    private var searchViewSpy: SearchViewSpy!
    private var apiManager: SearchBookService!
    private var apiManagerEmptyData: SearchBookService!
    private var apiManagerWithError: SearchBookService!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        apiManager = ApiManagerMock()
        apiManagerWithError = ApiManagerMockWithError()
        apiManagerEmptyData = ApiManagerMockEmptyData()
        searchViewSpy = SearchViewSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        apiManager = nil
        apiManagerWithError = nil
        searchViewSpy = nil
    }

    func test_getBookList_withDataReturned() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(sut.searchList.count == 1)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertTrue(searchViewSpy.applySnapshotWasCalled)
    }
    
    func test_getBookList_withEmptyDataReturned() {
        sut = SearchPresenter(apiManager: apiManagerEmptyData)
        sut.view = searchViewSpy
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(sut.searchList.isEmpty)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertFalse(searchViewSpy.applySnapshotWasCalled)
    }

    func test_getBookList_withBookAlreadyInList() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.searchList = [FakeData.book]
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertFalse(searchViewSpy.applySnapshotWasCalled)
    }

    func test_getBookList_withErrorDataReturned() {
        sut = SearchPresenter(apiManager: apiManagerWithError)
        sut.view = searchViewSpy
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(sut.searchList.isEmpty)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertFalse(searchViewSpy.applySnapshotWasCalled)
    }
    
    func test_refreshingData() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.currentSearchKeywords = "Test"
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertTrue(searchViewSpy.applySnapshotWasCalled)
    }

    func test_clearData() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.clearData()
        XCTAssertTrue(sut.searchList.isEmpty)
        XCTAssertTrue(sut.noMoreBooksFound == false)
        XCTAssertTrue(searchViewSpy.applySnapshotWasCalled)
    }
}


class SearchViewSpy: SearchPresenterView {

    var applySnapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
 
    func applySnapshot(animatingDifferences: Bool) {
        applySnapshotWasCalled = true
    }
    
    func startActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
