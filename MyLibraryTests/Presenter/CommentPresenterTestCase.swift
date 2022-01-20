//
//  CommentPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class CommentPresenterTestCase: XCTestCase {

    private var sut: CommentPresenter!
    private var commentViewSpy: CommentPresenterViewSpy!
   
    override func setUp() {
        commentViewSpy = CommentPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        commentViewSpy = nil
    }
    
    // MARK: - Success
    func test_getComments_successfully() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: true),
                               messageService: MessageServiceMock(successTest: true))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.getComments()
        XCTAssertTrue(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_addComment_successfully() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: true),
                               messageService: MessageServiceMock(successTest: true))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.addComment(with: "", commentID: "")
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteComment_successfully() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: true),
                               messageService: MessageServiceMock(successTest: true))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.deleteComment(for: PresenterFakeData.comment)
        XCTAssertTrue(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_successfully() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: true),
                               messageService: MessageServiceMock(successTest: true))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.notifyUser(of: "", book: PresenterFakeData.book)
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    // MARK: - Fail
    func test_getComments_fail() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: false),
                               messageService: MessageServiceMock(successTest: false))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.getComments()
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_addComment_failed() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: false),
                               messageService: MessageServiceMock(successTest: false))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.addComment(with: "", commentID: "")
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteComment_failed() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: false),
                               messageService: MessageServiceMock(successTest: false))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.deleteComment(for: PresenterFakeData.comment)
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_fail() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: false),
                               messageService: MessageServiceMock(successTest: false))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.notifyUser(of: "", book: PresenterFakeData.book)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_NoBookDataAvailable_successfully() {
        sut = CommentPresenter(commentService: CommentServiceMock(successTest: true),
                               messageService: MessageServiceMock(successTest: true))
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.notifyUser(of: "", book: nil)
        XCTAssertFalse(commentViewSpy.showActivityWasCalled)
        XCTAssertFalse(commentViewSpy.stopActivityWasCalled)
    }
}

class CommentPresenterViewSpy: CommentsPresenterView {
    
    var snapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
  
    func applySnapshot(animatingDifferences: Bool) {
        snapshotWasCalled = true
    }
    
    func showActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
