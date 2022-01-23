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
    private let successTestPresenter = CommentPresenter(commentService: CommentServiceMock(successTest: true),
                                                        messageService: MessageServiceMock(successTest: true),
                                                        formatter: Formatter())
    private let failedTestPresenter = CommentPresenter(commentService: CommentServiceMock(successTest: false),
                                                       messageService: MessageServiceMock(successTest: false),
                                                       formatter: Formatter())
    
    override func setUp() {
        commentViewSpy = CommentPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        commentViewSpy = nil
    }
    
    // MARK: - Success
    func test_getComments_successfully() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.getComments()
        XCTAssertTrue(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_addComment_successfully() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.addComment(with: "", commentID: "")
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteComment_successfully() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.deleteComment(for: PresenterFakeData.comment)
        XCTAssertTrue(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_successfully() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.notifyUser(of: "", book: PresenterFakeData.book)
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_getCommentDetails_successFully() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.getCommentDetails(for: PresenterFakeData.comment) { _ in
            XCTAssertTrue(self.commentViewSpy.showActivityWasCalled)
            XCTAssertTrue(self.commentViewSpy.stopActivityWasCalled)
        }
    }
    
    func test_settingBookDetails() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.setBookDetails(for: PresenterFakeData.book) { _ in
            XCTAssertTrue(self.commentViewSpy.showActivityWasCalled)
            XCTAssertTrue(self.commentViewSpy.stopActivityWasCalled)
        }
    }
    
    func test_cellSwipeAction_whenDeleting() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.presentSwipeAction(for: PresenterFakeData.comment, actionType: .delete)
        XCTAssertFalse(commentViewSpy.addCommentToInputBarWasCalled)
    }
    
    func test_cellSwipeAction_whenediting() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.presentSwipeAction(for: PresenterFakeData.comment, actionType: .edit)
        XCTAssertTrue(commentViewSpy.addCommentToInputBarWasCalled)
    }
    // MARK: - Fail
    func test_getComments_fail() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.getComments()
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_addComment_failed() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.addComment(with: "", commentID: "")
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteComment_failed() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.deleteComment(for: PresenterFakeData.comment)
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_fail() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.notifyUser(of: "", book: PresenterFakeData.book)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_NoBookDataAvailable_successfully() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = PresenterFakeData.book
        sut.notifyUser(of: "", book: nil)
        XCTAssertFalse(commentViewSpy.showActivityWasCalled)
        XCTAssertFalse(commentViewSpy.stopActivityWasCalled)
    }
}

class CommentPresenterViewSpy: CommentsPresenterView {
   
    var addCommentToInputBarWasCalled = false
    var snapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
  
    func addCommentToInputBar(for comment: CommentModel) {
        addCommentToInputBarWasCalled =  true
    }
    
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
