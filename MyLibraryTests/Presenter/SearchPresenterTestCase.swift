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
    private var apiManager: ApiManagerProtocol!
    private var apiManagerWithError: ApiManagerProtocol!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        apiManager = ApiManagerMock()
        apiManagerWithError = ApiManagerMockWithError()
        searchViewSpy = SearchViewSpy()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        apiManager = nil
        apiManagerWithError = nil
        searchViewSpy = nil
    }
    
    // MARK: - tests
    func test_getBookList_withDataReturned() {
        sut = SearchPresenter(apiManager: apiManager)
        sut.view = searchViewSpy
        
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
      
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
       
    }
    
    func test_getBookList_withErrorDataReturned() {
        sut = SearchPresenter(apiManager: apiManagerWithError)
        sut.view = searchViewSpy
        
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
       
        XCTAssertTrue(searchViewSpy.stopActivityWasCalled)
        XCTAssertTrue(searchViewSpy.showActivityWasCalled)
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
    
    func displayBookFromBarCodeSearch(with book: Item?) {
        displayBookFromCodeWasCalled = true
    }
    
    func showActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
