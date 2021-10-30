//
//  SearchServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 30/10/2021.
//
@testable import MyLibrary
import XCTest
import Alamofire

class RecipeServiceTestCase: XCTestCase {
    
    private var session: Session!
    private var sut: NetworkService!
    private let url = URL(string: "myDefaultURL")!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        sut = NetworkService(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        session = nil
    }

    func test_givenAnISBN_whenRequestingBookList_thenSuccessResponse() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getData(with: .withIsbn(isbn: "")) { (result: Result <BookModel, Error>) in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
                XCTAssertEqual(books.items?.first?.volumeInfo?.title, "Tintin, Hergé et les autos")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeyWords_whenRequestingBookList_thenSuccessResponse() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getData(with: .withKeyWord(words: "")) { (result: Result <BookModel, Error>) in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
                XCTAssertEqual(books.items?.first?.volumeInfo?.title, "Tintin, Hergé et les autos")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenAnISBN_whenRequestingBookList_thenDataError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookIncorrectData)
        }

        sut.getData(with: .withIsbn(isbn: "")) { (result: Result <BookModel, Error>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
   
}

