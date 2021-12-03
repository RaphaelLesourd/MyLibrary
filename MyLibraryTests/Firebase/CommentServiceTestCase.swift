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
    private var sut            : CommentServiceProtocol?
    private var libraryservice : LibraryService?
    private var userService    : UserService?
    
    private let imageData  = Data()
    private let comment = CommentModel(uid: "commentID", userID: "user", comment: "comment text", timestamp: 0)
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut         = CommentService()
        userService = UserService()
        Networkconnectivity.shared.status = .satisfied
    }
   
    override func tearDown() {
        super.tearDown()
        sut     = nil
      //  clearFirestore()
    }
   
    // MARK: - Success
    func test_givenCommentText_whenAddingComment_returnNoError() {
        let user = createUser()
        let book = createBookDocument()
        userService?.userID = user.userId
        libraryservice?.userID = user.userId
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: user, completion: { error in
            XCTAssertNil(error)
            self.libraryservice?.createBook(with: book, and: self.imageData, completion: { error in
                XCTAssertNil(error)
                self.sut?.addComment(for: book.bookID!, ownerID: book.ownerID!, commentID: self.comment.uid, comment: self.comment.comment!, completion: { error in
                    XCTAssertNil(error)
                    expectation.fulfill()
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
}
