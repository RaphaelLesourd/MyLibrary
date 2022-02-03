//
//  PostNotificationsTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 03/02/2022.
//

import Foundation

@testable import MyLibrary
import XCTest
import Alamofire

class PostNotificationsTestCase: XCTestCase {

    private var session: Session!
    private var sut: PostNotificationService!
    private let url = URL(string: "myDefaultURL")!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        sut = FirebaseCloudMessagingService(session: session)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        session = nil
    }

    // MARK: - Success
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
