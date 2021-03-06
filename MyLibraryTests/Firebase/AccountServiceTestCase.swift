//
//  AccountServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 14/12/2021.
//

@testable import MyLibrary
import XCTest

class AccountServiceTestCase: XCTestCase {
    
    // MARK: - Properties
    private var sut: AccountService!

    override func setUpWithError() throws {
        Networkconnectivity.shared.status = .satisfied
        sut = AccountService(userService: UserService(),
                             libraryService: LibraryService(),
                             categoryService: CategoryService())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        clearFirestore()
    }
    
    // MARK: - Success
    func test_givenCreatedAccountEmailAdress_whenRequestingPasswordReset_thenReturnNoError() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.createAccount(for: FakeData.accountCredentials) { _ in
            self.sut.sendPasswordReset(for: FakeData.accountCredentials.email) { error in
                XCTAssertNil(error)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenUserCrediential_whenDeletingAccount_thenReturnNoError() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.deleteAccount(with: FakeData.accountCredentials) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenCreatedAccount_whenlogin_thenReturnNoError() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.createAccount(for: FakeData.accountCredentials) { _ in
            self.sut.login(with: FakeData.accountCredentials, completion: { error in
                XCTAssertNil(error)
                exp.fulfill()
            })
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Failure
    func test_givenMismatchedPasswordUserCredential_whenCreatingAccount_thenReturnError() {
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.createAccount(for: FakeData.accountCredentialsPassWordMismatch) { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.passwordMismatch.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenNoNetworkConnection_whenCreatingAccount_thenReturnError() {
        Networkconnectivity.shared.status = .unsatisfied
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.createAccount(for: FakeData.accountCredentials) { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noNetwork.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenNoNetworkConnection_whenDeletingAccount_thenReturnError() {
        Networkconnectivity.shared.status = .unsatisfied
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.deleteAccount(with: FakeData.accountCredentials) { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noNetwork.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_givenNoNetworkConnection_whenRequestingPasswordReset_thenReturnError() {
        Networkconnectivity.shared.status = .unsatisfied
        let exp = XCTestExpectation(description: "Waiting for async operation")
        sut.sendPasswordReset(for: FakeData.accountCredentials.email) { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noNetwork.description)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
