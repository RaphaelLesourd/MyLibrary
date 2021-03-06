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
                                                        userService: UserServiceMock(successTest: true),
                                                        formatter: Formatter())
    private let failedTestPresenter = CommentPresenter(commentService: CommentServiceMock(successTest: false),
                                                       messageService: MessageServiceMock(successTest: false),
                                                       userService: UserServiceMock(successTest: false),
                                                       formatter: Formatter())
    
    override func setUp() {
        commentViewSpy = CommentPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        commentViewSpy = nil
    }
    
    // MARK: - Success
    func test_getComments_whenBookNotNil() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.getComments()
        XCTAssertTrue(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_addComment_whenBookNotNil() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.addComment(with: "", commentID: "")
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteComment_successfully() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.deleteComment(for: FakeData.comment)
        XCTAssertTrue(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_successfully() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.notifyUser(of: "", book: FakeData.book)
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
   
    func test_settingBookDetails_whenBookIsNotNil() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.getBookDetails()
        XCTAssertTrue(self.commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(self.commentViewSpy.stopActivityWasCalled)
        XCTAssertTrue(self.commentViewSpy.snapshotWasCalled)
    }
    
    func test_cellSwipeAction_whenDeleting() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.presentSwipeAction(for: FakeData.comment, actionType: .delete)
        XCTAssertFalse(commentViewSpy.addCommentToInputBarWasCalled)
    }
    
    func test_cellSwipeAction_whenediting() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.presentSwipeAction(for: FakeData.comment, actionType: .edit)
        XCTAssertTrue(commentViewSpy.addCommentToInputBarWasCalled)
    }
    
    func test_makeCommentCellRepresentable() {
        sut = successTestPresenter
        let representable = sut.makeCommentCellUI(with: FakeData.comment)
        XCTAssertEqual(representable.userName, FakeData.comment.userName.capitalized)
        XCTAssertEqual(representable.message, FakeData.comment.message)
    }
    // MARK: - Fail
    func test_getComments_fail() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.getComments()
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_getComments_whenBookNil() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.getComments()
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertFalse(commentViewSpy.showActivityWasCalled)
        XCTAssertFalse(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_addComment_failed() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.addComment(with: "", commentID: "")
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_addComment_whenBookNil() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.addComment(with: "", commentID: "")
        XCTAssertFalse(commentViewSpy.showActivityWasCalled)
        XCTAssertFalse(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteComment_failed() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.deleteComment(for: FakeData.comment)
        XCTAssertFalse(commentViewSpy.snapshotWasCalled)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_fail() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.notifyUser(of: "", book: FakeData.book)
        XCTAssertTrue(commentViewSpy.showActivityWasCalled)
        XCTAssertTrue(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_notifyingUser_NoBookDataAvailable_successfully() {
        sut = failedTestPresenter
        sut.view = commentViewSpy
        sut.book = FakeData.book
        sut.notifyUser(of: "", book: nil)
        XCTAssertFalse(commentViewSpy.showActivityWasCalled)
        XCTAssertFalse(commentViewSpy.stopActivityWasCalled)
    }
    
    func test_settingBookDetails_whenBookIsNil() {
        sut = successTestPresenter
        sut.view = commentViewSpy
        sut.getBookDetails()
        XCTAssertFalse(self.commentViewSpy.showActivityWasCalled)
        XCTAssertFalse(self.commentViewSpy.stopActivityWasCalled)
        XCTAssertFalse(self.commentViewSpy.snapshotWasCalled)
    }
}

class CommentPresenterViewSpy: CommentsPresenterView {
   
    var addCommentToInputBarWasCalled = false
    var snapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
  
    func addCommentToInputBar(for comment: CommentDTO) {
        addCommentToInputBarWasCalled =  true
    }
    
    func applySnapshot(animatingDifferences: Bool) {
        snapshotWasCalled = true
    }
    
    func startActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
