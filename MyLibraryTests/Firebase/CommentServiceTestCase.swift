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
    private var book: Item!
    private let imageData  = Data()
    private let comment = CommentModel(uid: "commentID",
                                       userID: "user1",
                                       userName: "name",
                                       userPhotoURL: "",
                                       message: "comment text",
                                       timestamp: 0)
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = CommentService()
        userService = UserService()
        libraryservice = LibraryService()
        book = createBookDocumentData()
        createUserInDatabase()
        createBookInDataBase()
    }
   
    override func tearDown() {
        super.tearDown()
        sut = nil
        clearFirestore()
    }
    
    private func createUserInDatabase() {
        let newUser = createUserData()
        let exp = XCTestExpectation(description: "Waiting for async operation")
        userService.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.userService.userID = newUser.userID
            self.libraryservice.userID = newUser.userID
            self.sut.userID = newUser.userID
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
                               commentID: self.comment.uid,
                               comment: self.comment.message,
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
                               commentID: self.comment.uid,
                               comment: self.comment.message,
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
                          commentID: self.comment.uid,
                          comment: self.comment.message,
                          completion: { error in
            XCTAssertNil(error)
            self.sut.deleteComment(for: bookID, ownerID: ownerID, comment: self.comment) { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenComment_whenRetrivingUserDetail_thenReturnUser() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        sut.getUserDetail(for: "user1") { result in
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
}
