//
//  CategoryPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 19/01/2022.
//

import XCTest
import Alamofire
@testable import MyLibrary


class SearchPresenterTestCase: XCTestCase {

    private var sut: SearchPresenter!
    private var searchVcMock: SearchViewControllerMock!
    private let url = URL(string: "myDefaultURL")!
  
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = Session(configuration: configuration)
        let apiManager = ApiManager(session: session, validator: Validator())
        sut = SearchPresenter(apiManager: apiManager)
        searchVcMock = SearchViewControllerMock(presenter: sut)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - tests
    func test_getBookList_withDataReturned() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(searchVcMock.activityIndicatorIsShowing)
        XCTAssertNotNil(searchVcMock.books)
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.3)
    }
    
    func test_getBookList_withErrorDataReturned() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(with: "Tintin, Hergé et les autos", fromIndex: 0)
        XCTAssertTrue(searchVcMock.activityIndicatorIsShowing)
        XCTAssertNotNil(searchVcMock.books)
        XCTAssertTrue(searchVcMock.books.count == 0)
        expectation.fulfill()
        wait(for: [expectation], timeout: 0.3)
    }

}


class SearchViewControllerMock: SearchPresenterView {

    var presenter: SearchPresenter
    var activityIndicatorIsShowing = Bool()
    
    init(presenter: SearchPresenter) {
        self.presenter = presenter
        self.presenter.view = self
    }
    var books: [Item] = []
   
    
    func handleList(for books: [Item]) {
        self.books = books
    }
    
    func showActivityIndicator() {
        activityIndicatorIsShowing = true
    }
    
    func stopActivityIndicator() {
        activityIndicatorIsShowing = false
    }
}
