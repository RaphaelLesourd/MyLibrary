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
    private var sut: ApiManager!
    private let url = URL(string: "myDefaultURL")!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        sut = ApiManager(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        session = nil
    }

    // MARK: - Success
    func test_givenAnISBN_whenRequestingBookList_thenSuccessResponse() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getData(with: "9791234567891", fromIndex: 0) { (result: Result <[Item], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
                XCTAssertEqual(books.first?.volumeInfo?.title, "Tintin, Hergé et les autos")
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
        sut.getData(with: "Tintin", fromIndex: 0) { (result: Result <[Item], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
                XCTAssertEqual(books.first?.volumeInfo?.title, "Tintin, Hergé et les autos")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeywords_WhenRequestingBookList_thenResultReturned() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookEmptyCorrectData)
        }
        sut.getData(with: "Tintin", fromIndex: 0) { (result: Result <[Item], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
                XCTAssertEqual(books.count, 0)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.noBooks.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
 // MARK: - Errors
    func test_givenAnISBN_whenRequestingBookList_thenDataError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookIncorrectData)
        }

        sut.getData(with: "Tintin", fromIndex: 0) { (result: Result <[Item], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, ApiError.afError(.responseSerializationFailed(reason: .decodingFailed(error: DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))))))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    func test_givenAnEmptyQuery_whenRequestingBookList_thenDataError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }

        sut.getData(with: "", fromIndex: 0) { (result: Result <[Item], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.emptyQuery.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenNilQuery_whenRequestingBookList_thenDataError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }

        sut.getData(with: nil, fromIndex: 0) { (result: Result <[Item], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.emptyQuery.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
   
}

