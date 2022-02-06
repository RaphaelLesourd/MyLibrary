//
//  MessageServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 06/02/2022.
//

import XCTest
import Alamofire
@testable import MyLibrary

class MessageServiceTestCase: XCTestCase {

    private var sut: MessageService!
    private var notificationService: PostNotificationService!
    private var session: Session!
    private var userService: UserService!
    private let url = URL(string: "myDefaultURL")!

    override func setUp() {
        userService = UserService()
        createUserInDatabase()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        notificationService = FirebaseCloudMessagingService(session: session)
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        sut = MessageService(postNotificationService: notificationService)
    }

    override func tearDown() {
        sut = nil
        clearFirestore()
    }

    private func createUserInDatabase() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        userService.createUserInDatabase(for: FakeData.user, completion: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
    }
    

    func test_PostMessage_fromCommentList() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.sendCommentPushNotification(for: FakeData.book,
                                           message: "Message",
                                           for: FakeData.commentList) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_PostMessage_fromNilBookData() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.sendCommentPushNotification(for: FakeData.bookNilBookData,
                                           message: "Message",
                                           for: FakeData.commentList) { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.unableToSendMessage.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_PostMessage_fromEmptyCommentList() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.sendCommentPushNotification(for: FakeData.book,
                                           message: "Message",
                                           for: []) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
