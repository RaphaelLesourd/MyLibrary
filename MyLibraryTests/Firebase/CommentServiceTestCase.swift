//
//  CommentServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 01/12/2021.
//

@testable import MyLibrary
import XCTest

class CommentServiceTestCase: XCTestCase {
    
    // MARK: - Propserties
    private var sut: CommentService!
    private var libraryservice: LibraryService!
    private var userService: UserService!
    private var book: ItemDTO!
    private let imageData  = Data()
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = CommentService(userService: UserService())
        userService = UserService()
        libraryservice = LibraryService()
        book = FakeData.book
        createUserInDatabase()
        createBookInDataBase()
    }
   
    override func tearDown() {
        super.tearDown()
        sut = nil
        clearFirestore()
    }
    
    private func createUserInDatabase() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        userService.createUserInDatabase(for: FakeData.user, completion: { error in
            XCTAssertNil(error)
            self.userService.userID = FakeData.user.userID
            self.libraryservice.userID = FakeData.user.userID
            self.sut.userID = FakeData.user.userID
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
    }
    
    private func createBookInDataBase() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        self.libraryservice.createBook(with: self.book, and: self.imageData, completion: { error in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Success
    func test_givenCommentText_whenAddingComment_returnNoError() {
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        self.sut.addComment(for: bookID,
                               ownerID: ownerID,
                               commentID: FakeData.comment.uid,
                               comment: FakeData.comment.message,
                               completion: { error in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenBookID_whenRetrievingComments_returnCommentList() {
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        self.sut.addComment(for: bookID,
                               ownerID: ownerID,
                               commentID: FakeData.comment.uid,
                               comment: FakeData.comment.message,
                               completion: { error in
            XCTAssertNil(error)
            self.sut.getComments(for: bookID, ownerID: ownerID) {result in
                switch result {
                case .success(let comments):
                    XCTAssertNotNil(comments)
                case .failure(let error):
                    XCTAssertNil(error)
                }
                expectation.fulfill()
            }
        })
       wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenBoolID_whenDeletingBook_returnNoError() {
        guard let bookID = book.bookID,
              let ownerID = book.ownerID else { return }
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        sut.addComment(for: bookID,
                          ownerID: ownerID,
                          commentID:FakeData.comment.uid,
                          comment: FakeData.comment.message,
                          completion: { error in
            XCTAssertNil(error)
            self.sut.deleteComment(for: bookID, ownerID: ownerID, comment: FakeData.comment) { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 1.0)
    }
}
