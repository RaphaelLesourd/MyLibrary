//
//  SearchServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 30/10/2021.
//
@testable import MyLibrary
import XCTest
import Alamofire

class ApiManagerTestCase: XCTestCase {
    
    private var session: Session!
    private var sut: GoogleBooksService!
    private let url = URL(string: "myDefaultURL")!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        sut = GoogleBooksService(session: session, validation: Validation())
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
        sut.getBooks(for: "9791234567891", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
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
        sut.getBooks(for: "Tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
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
    
    func test_givenKeywords_WhenRequestingBookList_thenEmptyResultReturned() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookEmptyCorrectData)
        }
        sut.getBooks(for: "nothing", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNotNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.noBooks.description)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPosting_thenReturnNoError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Errors
    func test_givenAnISBN_whenRequestingBookList_thenDataError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookIncorrectData)
        }
        
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
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
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        
        sut.getBooks(for: "", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
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
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        
        sut.getBooks(for: nil, fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
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
    
    func test_givenKeyWords_whenRequestingBookListWithRequestNoValid_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(400).description)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeyWords_whenRequestingBookListWithAccessNotAuthorized_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(401).description)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeyWords_whenRequestingBookListWithAccessForbidden_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(403).description)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeyWords_whenRequestingBookListWithNothingFound_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(404).description)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeyWords_whenRequestingBookListWithTooManyRequests_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 429, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(429).description)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeyWords_whenRequestingBookListWithInternalServerError_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(500).description)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenKeyWords_whenRequestingBookListWithServiceUnvailable_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 503, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.bookCorrectData)
        }
        sut.getBooks(for: "tintin", fromIndex: 0) { (result: Result <[ItemDTO], ApiError>) in
            switch result {
            case .success(let books):
                XCTAssertNil(books)
            case .failure(let error):
                XCTAssertEqual(error.description, ApiError.httpError(503).description)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Message Errors
    func test_givenMessage_whenPostingWithRequestNoValid_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertEqual(error?.description, ApiError.httpError(400).description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPostingWithAccessNotAuthorized_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertEqual(error?.description, ApiError.httpError(401).description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPostingWithAccessForbidden_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertEqual(error?.description, ApiError.httpError(403).description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPostingWithNothingFound_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertEqual(error?.description, ApiError.httpError(404).description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPostingWithTooManyRequests_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 429, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertEqual(error?.description, ApiError.httpError(429).description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPostingWithInternalServerError_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertEqual(error?.description, ApiError.httpError(500).description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPostingWithServiceUnvailable_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 503, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertEqual(error?.description, ApiError.httpError(503).description)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenMessage_whenPostingWithOtherErrors_thenReturnError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: -1, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut.sendPushNotification(with: FakeData.correctMessageToPost) { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

