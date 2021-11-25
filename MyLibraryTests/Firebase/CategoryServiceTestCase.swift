//
//  CategoryServiceTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 23/11/2021.
//

@testable import MyLibrary
import XCTest
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift

class CategoryServiceTestCase: XCTestCase {
    // MARK: - Propserties
    private var sut : CategoryService?
    private var book: Item?
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = CategoryService.shared
        sut?.userID = "bLD1HPeHhqRz7UZqvkIOOMgxGdD3"
    }
    
    override func tearDown() {
        super.tearDown()
        sut?.categories.removeAll()
        sut  = nil
        book = nil
    }
  
    // MARK: - Success
    func test_givenCategory_whenAdding_thenAddedToTheCategoriesList() {
        sut?.addCategory(for: "Movie", completion: { error in
            XCTAssertNil(error)
            XCTAssertEqual(self.sut?.categories.count, 1)
        })
    }
    
    func test_givenCategoryList_whenGettingList_thenDisplayList() {
        sut?.addCategory(for: "test", completion: { error in
            XCTAssertNil(error)
            self.sut?.getCategories(completion: { error in
                XCTAssertEqual(self.sut?.categories.count, 1)
            })
        })
    }
    
    // MARK: - Failure
    func test_givenCategory_whenAddingExistingCategory_thenError() {
        sut?.addCategory(for: "TV", completion: { error in
            XCTAssertNil(error)
            self.sut?.addCategory(for: "TV", completion: { error in
                XCTAssertNotNil(error)
            })
        })
    }
    
    func test_givenEmptyCategory_whenAdding_thenEmptyError() {
        sut?.addCategory(for: "", completion: { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.description, FirebaseError.noCategory.description)
        })
    }

    func test_givenEmptyCategoryList_whenGettingList_thenNothingFoundError() {
        sut?.getCategories(completion: { error in
            XCTAssertNotNil(error)
        })
    }
}
