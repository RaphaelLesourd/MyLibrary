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
    }
    
    override func tearDown() {
        super.tearDown()
      //  clearFirestore()
        sut?.categories.removeAll()
        sut  = nil
        book = nil
    }

    // MARK: - Private function
    private func createBookDocument() -> Item? {
        let volumeInfo = VolumeInfo(title: "title",
                                    authors: ["author"],
                                    publisher: "publisher",
                                    publishedDate: "1900",
                                    volumeInfoDescription:"decription",
                                    industryIdentifiers: [IndustryIdentifier(identifier:"1234567890")],
                                    pageCount: 0,
                                    ratingsCount: 0,
                                    imageLinks: ImageLinks(thumbnail: "thumbnailURL"),
                                    language: "language")
        let saleInfo = SaleInfo(retailPrice: SaleInfoListPrice(amount: 0.0, currencyCode: "CUR"))
        return Item(etag: "11111111111",
                    favorite: false,
                    volumeInfo: volumeInfo,
                    saleInfo: saleInfo,
                    timestamp: 1,
                    category: [])
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
                XCTAssertEqual(error?.description, FirebaseError.documentAlreadyExist("TV").description)
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
            XCTAssertEqual(error?.description, FirebaseError.nothingFound.description)
        })
    }
}
