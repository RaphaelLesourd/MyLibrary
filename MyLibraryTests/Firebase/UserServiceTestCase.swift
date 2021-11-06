//
//  UserServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 04/11/2021.
//

import XCTest
@testable import MyLibrary
import CoreMedia

class UserServiceTestCase: XCTestCase {
    
    var sut: UserServiceProtocol?

    override func setUp() {
        super.setUp()
        sut = UserService()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
  func test_givenNewUser_whenStoringData_thenItReturnsNoErrors() {
    let exp = self.expectation(description: "Waiting for async operation")
    let newUser = CurrentUser(id: "1", displayName: "raph", email: "raph@raph.com", photoURL: "")
    // when
      self.sut?.createUserInDatabase(for: newUser, completion: { error in
         // then
          XCTAssertNil(error)
          exp.fulfill()
      })
    self.waitForExpectations(timeout: 10, handler: nil)
  }
    
    func test_givenUserStrored_whenRetreivingUser_thenShowData() {
        let newUser = CurrentUser(id: "2", displayName: "raph", email: "raph@raph.com", photoURL: "")
        let exp = self.expectation(description: "Waiting for async operation")
        // when
          self.sut?.createUserInDatabase(for: newUser, completion: { error in
             // then
              XCTAssertNil(error)

              self.sut?.retrieveUser(completion: { result in
                  switch result {

                  case .success(let user):
                      XCTAssertNotNil(user)
                      XCTAssertEqual(user?.email, newUser.email)
                      XCTAssertEqual(user?.id, newUser.id)
                      XCTAssertEqual(user?.displayName, newUser.displayName)
                  case .failure(let error):
                      XCTAssertNil(error)
                  }
              })
              exp.fulfill()
          })
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Errors
    func test_givenNoUser_whenRetrivingNonExistingUser_thenReturnError() {
        let exp = self.expectation(description: "Waiting for async operation")
        // when
        self.sut?.retrieveUser(completion: { result in
            switch result {
            case .success(let user):
                XCTAssertNil(user)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
        exp.fulfill()
        self.waitForExpectations(timeout: 10, handler: nil)
    }

}
