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

    func test_getBookList_withDataReturned_forKeyWordSearch() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.searchType = .keywordSearch
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(sut.searchList.count == 1)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertTrue(searchViewSpy.applySnapshotWasCalled)
    }
    
    func test_getBookList_withEmptyDataReturned_forKeyWordSearch() {
        sut = SearchPresenter(apiManager: apiManagerEmptyData)
        sut.view = searchViewSpy
        sut.searchType = .keywordSearch
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(sut.searchList.isEmpty)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertFalse(searchViewSpy.applySnapshotWasCalled)
    }
    
    func test_getBookList_withDataReturned_forBarcodeSearch() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.searchType = .barCodeSearch
        sut.getBooks(with: "12345", fromIndex: 0)
        XCTAssertTrue(sut.searchList.isEmpty)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertTrue(searchViewSpy.displayBookFromCodeWasCalled)
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

    func test_getBookList_withDataReturned_forKeyWordSearch_bookAlreadyExist() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.searchType = .keywordSearch
        sut.searchList = FakeData.books
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(sut.searchList.count == 1)
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
        XCTAssertFalse(searchViewSpy.applySnapshotWasCalled)
    }
    
    func test_refreshingData_noError_forKeywordSearch() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        sut.searchType = .keywordSearch
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
    
    var displayBookFromCodeWasCalled = false
    var applySnapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
 
    func applySnapshot(animatingDifferences: Bool) {
        applySnapshotWasCalled = true
    }
    
    func displayBookFromBarCodeSearch(with book: ItemDTO?) {
        displayBookFromCodeWasCalled = true
    }
    
    func startActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
