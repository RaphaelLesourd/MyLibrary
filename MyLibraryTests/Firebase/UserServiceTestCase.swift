//
//  UserServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 04/11/2021.
//

@testable import MyLibrary
import XCTest

class UserServiceTestCase: XCTestCase {
    // MARK: - Propserties
    private var sut           : UserService?
    private var accountService: AccountService?
    private var exp           : XCTestExpectation?

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        Networkconnectivity.shared.status = .satisfied
        exp = self.expectation(description: "Waiting for async operation")
        sut = UserService()
        accountService = AccountService()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        exp = nil
        accountService = nil
        clearFirestore()
    }

    // MARK: - Successful
    func test_givenUserStored_whenRetreivingUser_thenShowData() {
        let newUser = createUser()
        // when
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.retrieveUser(completion: { result in
                switch result {
                case .success(let user):
                    // then
                    XCTAssertNotNil(user)
                    XCTAssertEqual(user?.email, newUser.email)
                    XCTAssertEqual(user?.id, newUser.id)
                    XCTAssertEqual(user?.displayName, newUser.displayName)
                case .failure(let error):
                    XCTAssertNil(error)
                }
                self.exp?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenUserStored_whenUpdatingName_thenDisplayNewName() {
        let newUser = createUser()
        // Given
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            // When
            XCTAssertNil(error)
            self.sut?.updateUserName(with: "updatedName", completion: { error in
                if let error = error {
                    XCTAssertNil(error)
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
                    self.exp?.fulfill()
                })
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenUserStored_whenDeleting_thenNoError() {
        let newUser = createUser()
        // Given
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            //When
            XCTAssertNil(error)
            self.sut?.deleteUser(completion: { error in
                //then
                XCTAssertNil(error)
                self.exp?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - Errors
    func test_givenNoUser_whenRetrivingNonExistingUser_thenReturnError() {
        let newUser = createUser()
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.userID = "12"
            // when
            self.sut?.retrieveUser(completion: { result in
                switch result {
                case .success(let user):
                    XCTAssertNil(user)
                case .failure(let error):
                    // Then
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error.description, FirebaseError.noUserName.description)
                }
                self.exp?.fulfill()
            })
        })
        self.waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_givenUser_whenUpdatingNameNoConnectivity_thenConnectivityError() {
        let newUser = createUser()
        // Given
        self.sut?.createUserInDatabase(for: newUser, completion: { error in
            // When
            XCTAssertNil(error)
            Networkconnectivity.shared.status = .unsatisfied
            self.sut?.updateUserName(with: "updatedName", completion: { error in
                // Then
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.description, FirebaseError.noNetwork.description)
                self.exp?.fulfill()
            })
       })
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_givenNoUSerStored_whenUpdatingName_thenError() {
        // When
        sut?.userID = "12"
        self.sut?.updateUserName(with: "", completion: { error in
            // Then
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noUserName.description)
            self.exp?.fulfill()
        })
        self.waitForExpectations(timeout: 20, handler: nil)
    }
}
