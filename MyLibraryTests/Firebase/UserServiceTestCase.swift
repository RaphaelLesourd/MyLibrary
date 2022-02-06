//
//  UserServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 04/11/2021.
//

@testable import MyLibrary
import XCTest

class UserServiceTestCase: XCTestCase {

    private var sut: UserService!

    override func setUp() {
        super.setUp()
        Networkconnectivity.shared.status = .satisfied
        sut = UserService()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        clearFirestore()
    }

    private func createUserInDatabase() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.createUserInDatabase(for: FakeData.user, completion: { error in
            XCTAssertNil(error)
            self.sut.userID = FakeData.user.userID
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Successful
    func test_givenUserStored_whenRetreivingUser_thenShowData() {
        // when
        let exp = XCTestExpectation(description: "Waiting for async operation")
        createUserInDatabase()
        sut.retrieveUser(for: sut.userID, completion: { result in
            switch result {
            case .success(let user):
                // then
                XCTAssertNotNil(user)
                XCTAssertEqual(user?.email, "testuser@test.com")
                XCTAssertEqual(user?.displayName, "testuser")
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
        createUserInDatabase()
        self.sut.updateUserName(with: "updatedName", completion: { error in
            XCTAssertNil(error)
            // Then
            self.sut.retrieveUser(for: self.sut.userID, completion: { result in
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
        wait(for: [exp], timeout: 2.0)
    }
    
    func test_givenUserStored_whenDeleting_thenNoError() {
        // Given
        let exp = XCTestExpectation(description: "Waiting for async operation")
        createUserInDatabase()
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
        createUserInDatabase()
        self.sut?.userID = "12"
        // when
        self.sut?.retrieveUser(for: sut.userID, completion: { result in
            switch result {
            case .success(let user):
                XCTAssertNil(user)
            case .failure(let error):
                // Then
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, FirebaseError.nothingFound.description)
            }
        })
        exp.fulfill()
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
