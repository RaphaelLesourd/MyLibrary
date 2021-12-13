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
    private var sut: UserService!

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        Networkconnectivity.shared.status = .satisfied
        sut = UserService()
        createUserInDatabase()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        clearFirestore()
    }

    private func createUserInDatabase() {
        let newUser = createUserData()
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut.userID = newUser.userID
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
    }
    // MARK: - Successful
    func test_givenUserStored_whenRetreivingUser_thenShowData() {
        let newUser = createUserData()
        // when
        let exp = XCTestExpectation(description: "Waiting for async operation")
       
            self.sut.retrieveUser(completion: { result in
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
                exp.fulfill()
            })
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenUserStored_whenUpdatingName_thenDisplayNewName() {
        // Given
        let exp = XCTestExpectation(description: "Waiting for async operation")
            self.sut.updateUserName(with: "updatedName", completion: { error in
                XCTAssertNil(error)
                // Then
                self.sut.retrieveUser(completion: { result in
                    switch result {
                    case .success(let user):
                        XCTAssertNotNil(user)
                        XCTAssertEqual(user?.displayName, "updatedName")
                    case .failure(let error):
                        XCTAssertNotNil(error)
                    }
                    exp.fulfill()
                })
            })
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenUserStored_whenDeleting_thenNoError() {
        // Given
        let exp = XCTestExpectation(description: "Waiting for async operation")
            self.sut.deleteUser(completion: { error in
                //then
                XCTAssertNil(error)
                exp.fulfill()
            })
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Errors
    func test_givenNoUser_whenRetrivingNonExistingUser_thenReturnError() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
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
                exp.fulfill()
            })
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenNoUSerStored_whenUpdatingName_thenError() {
        // When
        sut.userID = "12"
        let exp = XCTestExpectation(description: "Waiting for async operation")
        self.sut.updateUserName(with: "", completion: { error in
            // Then
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noUserName.description)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
    }
}
