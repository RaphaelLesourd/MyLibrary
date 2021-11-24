//
//  UserServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 04/11/2021.
//

import XCTest
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift
@testable import MyLibrary

class UserServiceTestCase: XCTestCase {
    // MARK: - Propserties
    private var sut: UserService?
    private var accountService: AccountService?
    private let userID = "1"
    private let credentials = AccountCredentials(userName: "testuser",
                                                 email: "test@test.com",
                                                 password: "Test21@",
                                                 confirmPassword: "Test21@")
    private lazy var newUser = CurrentUser(userId: "1",
                                           displayName: credentials.userName ?? "test",
                                           email: credentials.email,
                                           photoURL: "")
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = UserService()
        accountService = AccountService()
    }
    
    override func tearDown() {
        super.tearDown()
        clearFirestore()
        sut = nil
        accountService = nil
    }
    
    // MARK: - Successful
    func test_givenNewUser_whenStoringData_thenItReturnsNoErrors() {
        let exp = self.expectation(description: "Waiting for async operation")
        // when
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            // then
            XCTAssertNil(error)
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenUserStored_whenRetreivingUser_thenShowData() {
        // when
        let exp = self.expectation(description: "Waiting for async operation")
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.retrieveUser(completion: { result in
                switch result {
                case .success(let user):
                    // then
                    XCTAssertNotNil(user)
                    XCTAssertEqual(user?.email, self.newUser.email)
                    XCTAssertEqual(user?.id, self.newUser.id)
                    XCTAssertEqual(user?.displayName, self.newUser.displayName)
                case .failure(let error):
                    XCTAssertNil(error)
                }
            })
        })
        exp.fulfill()
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenUserStored_whenUpdatingName_thenDisplayNewName() {
        // Given
        let exp = self.expectation(description: "Waiting for async operation")
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            // When
            XCTAssertNil(error)
            self.sut?.updateUserName(with: "updatedName", completion: { error in
                if let error = error {
                    XCTAssertNotNil(error)
                }
                // Then
                self.sut?.retrieveUser(completion: { result in
                    switch result {
                    case .success(let user):
                        XCTAssertNotNil(user)
                        XCTAssertEqual(user?.displayName, "updatedName")
                    case .failure(let error):
                        XCTAssertNotNil(error)
                    }
                })
            })
        })
        exp.fulfill()
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenUserStored_whenDeleting_thenNoError() {
        // Given
        let exp = self.expectation(description: "Waiting for async operation")
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            if let error = error {
                XCTAssertNotNil(error)
            }
            //When
            self.sut?.deleteUser(completion: { error in
                //then
                if let error = error {
                    XCTAssertNotNil(error)
                }
                
            })
        })
        exp.fulfill()
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - Errors
    func test_givenNoUser_whenRetrivingNonExistingUser_thenReturnError() {
        let exp = self.expectation(description: "Waiting for async operation")
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            if let error = error {
                XCTAssertNotNil(error)
            }
            self.sut?.userID = "12"
            // when
            self.sut?.retrieveUser(completion: { result in
                switch result {
                case .success(let user):
                    XCTAssertNil(user)
                case .failure(let error):
                    // Then
                    XCTAssertNotNil(error)
                }
            })
        })
        exp.fulfill()
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenNoUSerStored_whenUpdatingName_thenError() {
        let exp = self.expectation(description: "Waiting for async operation")
        // When
        sut?.userID = "12"
        self.sut?.updateUserName(with: "", completion: { error in
            if let error = error {
                // Then
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
//    func test_givenNoUserStored_whenDeleting_thenError() {
//        let exp = self.expectation(description: "Waiting for async operation")
//        //When
//        sut?.userId = "12"
//        self.sut?.deleteUser(completion: { error in
//            //then
//            if let error = error {
//                XCTAssertNotNil(error)
//            }
//        })
//        exp.fulfill()
//        self.waitForExpectations(timeout: 10, handler: nil)
//    }
}
