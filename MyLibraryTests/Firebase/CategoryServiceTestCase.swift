//
//  CategoryServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 23/11/2021.
//

@testable import MyLibrary
import XCTest

class CategoryServiceTestCase: XCTestCase {
    // MARK: - Propserties
    private var sut        : CategoryService?
    private var userService: UserServiceProtocol?
    
    private let credentials = AccountCredentials(userName: "testuser",
                                                 email: "testuser@test.com",
                                                 password: "Test21@",
                                                 confirmPassword: "Test21@")
    private lazy var newUser = CurrentUser(userId: "bLD1HPeHhqRz7UZqvkIOOMgxGdD3",
                                           displayName: credentials.userName ?? "test",
                                           email: credentials.email,
                                           photoURL: "")
  
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut         = CategoryService.shared
        sut?.userID = newUser.userId
        userService = UserService()
        Networkconnectivity.shared.status = .satisfied
    }
    
    override func tearDown() {
        super.tearDown()
        sut?.categories.removeAll()
        sut = nil
        clearFirestore()
    }
    
    
   
    // MARK: - Success
    func test_givenCategory_whenAdding_thenAddedToTheCategoriesList() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.addCategory(for: "Movie", completion: { error in
                XCTAssertNil(error)
                XCTAssertEqual(self.sut?.categories.count, 1)
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_givenCategoryList_whenRequestingList_thenDisplayList() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        dump(sut?.categories)
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.addCategory(for: "Movie", completion: { error in
                XCTAssertNil(error)
                dump(self.sut?.categories)
                self.sut?.getCategories(completion: { error in
                    XCTAssertNil(error)
                    dump(self.sut?.categories)
                    XCTAssertEqual(self.sut?.categories.first?.name, "movie")
                    expectation.fulfill()
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenCategoryList_whenUpdatingCategory_thenNameUpdated() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        dump(sut?.categories)
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.addCategory(for: "Movie", completion: { error in
                XCTAssertNil(error)
                dump(self.sut?.categories)
                self.sut?.getCategories(completion: { error in
                    XCTAssertNil(error)
                    dump(self.sut?.categories)
                    if let category = self.sut?.categories.first {
                        XCTAssertEqual(category.name, "movie")
                        dump(self.sut?.categories)
                        self.sut?.updateCategoryName(for: category, with: "Tv", completion: { error in
                            XCTAssertEqual(self.sut?.categories.first?.name, "Tv")
                            dump(self.sut?.categories)
                            expectation.fulfill()
                        })
                    }
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - Failure
    func test_givenCategory_whenAddingWithNoConnectivity_thenNoConnectivityError() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            Networkconnectivity.shared.status = .unsatisfied
            self.sut?.addCategory(for: "Movie", completion: { error in
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.description, FirebaseError.noNetwork.description)
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenEmptyCategory_whenAdding_thenEmptyNameError() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.addCategory(for: "", completion: { error in
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.description, FirebaseError.noCategory.description)
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenCategory_whenAddingExisitingCategory_thenAlreadyExistCategoryError() {
        let expectation = XCTestExpectation(description: "Waiting for async operation")
        userService?.createUserInDatabase(for: newUser, completion: { error in
            XCTAssertNil(error)
            self.sut?.addCategory(for: "Movie", completion: { error in
                XCTAssertNil(error)
                self.sut?.addCategory(for: "Movie", completion: { error in
                    XCTAssertNotNil(error)
                    XCTAssertEqual(error?.description, FirebaseError.categoryExist.description)
                    expectation.fulfill()
                })
            })
        })
        wait(for: [expectation], timeout: 1.0)
    }
}
