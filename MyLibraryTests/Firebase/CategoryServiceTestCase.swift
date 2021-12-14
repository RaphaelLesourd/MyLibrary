//
//  CategoryServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 23/11/2021.
//

//@testable import MyLibrary
//import XCTest
//
//class CategoryServiceTestCase: XCTestCase {
//    // MARK: - Properties
//    private var sut: CategoryService!
//    private var userService: UserService!
//    private var libraryService: LibraryService!
//    private var book: Item!
//    private let imageData = Data()
//
//    // MARK: - Lifecycle
//    override func setUp() {
//        super.setUp()
//        sut = CategoryService()
//        sut.categoriesListener?.remove()
//        libraryService = LibraryService()
//        userService = UserService()
//        book = createBookDocumentData()
//        createUserInDatabase()
//        createBookInDataBase()
//    }
//
//    override func tearDown() {
//        super.tearDown()
//        clearFirestore()
//        sut.categories.removeAll()
//        sut = nil
//        libraryService = nil
//        userService = nil
//    }
//
//    private func createUserInDatabase() {
//        let newUser = createUserData()
//        let exp = XCTestExpectation(description: "Waiting for async operation")
//        userService.createUserInDatabase(for: newUser, completion: { error in
//            XCTAssertNil(error)
//            self.userService.userID = newUser.userID
//            self.libraryService.userID = newUser.userID
//            self.sut.userID = newUser.userID
//            exp.fulfill()
//        })
//        wait(for: [exp], timeout: 1.0)
//    }
//
//    private func createBookInDataBase() {
//       let expectation = XCTestExpectation(description: "Waiting for async operation")
//        self.libraryService.createBook(with: self.book, and: self.imageData, completion: { error in
//            XCTAssertNil(error)
//            expectation.fulfill()
//        })
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    // MARK: - Success
//    func test_givenCategory_whenAdding_thenAddedToTheCategoriesList() {
//        let expectation = XCTestExpectation(description: "Waiting for async operation")
//
//        self.sut?.addCategory(for: "Travel", completion: { error in
//            XCTAssertNil(error)
//            XCTAssertEqual(self.sut?.categories.count, 1)
//            expectation.fulfill()
//        })
//        wait(for: [expectation], timeout: 1.0)
//    }
//
//    func test_givenCategoryList_whenRequestingList_thenDisplayList() {
//        let expectation = XCTestExpectation(description: "Waiting for async operation")
//        self.sut.addCategory(for: "Cinema", completion: { error in
//            XCTAssertNil(error)
//            self.sut.getCategories(completion: { error in
//                XCTAssertNil(error)
//                XCTAssertEqual(self.sut?.categories.count, 1)
//                expectation.fulfill()
//           })
//        })
//        wait(for: [expectation], timeout: 1.0)
//    }
//    
//    func test_givenCategoryList_whenUpdatingCategory_thenNameUpdated() {
//        let expectation = XCTestExpectation(description: "Waiting for async operation")
//        self.sut.addCategory(for: "Movie", completion: { error in
//            XCTAssertNil(error)
//            self.sut.getCategories(completion: { error in
//                XCTAssertNil(error)
//                if let category = self.sut?.categories.first {
//                    self.sut?.updateCategoryName(for: category, with: "Tv", completion: { error in
//                        XCTAssertEqual(self.sut?.categories.first?.name, "Tv")
//                    })
//                    expectation.fulfill()
//                }
//           })
//        })
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    // MARK: - Failure
//    func test_givenEmptyCategory_whenAdding_thenEmptyNameError() {
//        let expectation = XCTestExpectation(description: "Waiting for async operation")
//
//        self.sut.addCategory(for: "", completion: { error in
//            XCTAssertNotNil(error)
//            XCTAssertEqual(error?.description, FirebaseError.noCategory.description)
//            expectation.fulfill()
//        })
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//    
//    func test_givenCategory_whenAddingExisitingCategory_thenAlreadyExistCategoryError() {
//        let expectation = XCTestExpectation(description: "Waiting for async operation")
//
//        self.sut.addCategory(for: "BD", completion: { error in
//            XCTAssertNil(error)
//            self.sut.addCategory(for: "BD", completion: { error in
//                XCTAssertNotNil(error)
//                XCTAssertEqual(error?.description, FirebaseError.categoryExist.description)
//                expectation.fulfill()
//            })
//        })
//
//        wait(for: [expectation], timeout: 1.0)
//    }
//}
