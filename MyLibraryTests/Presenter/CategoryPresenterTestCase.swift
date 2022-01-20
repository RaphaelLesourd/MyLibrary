//
//  CategoryPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class CategoryPresenterTestCase: XCTestCase {
  
    private var sut: CategoryPresenter!
    private var categoryViewSpy: CategoryPresenterViewSpy!
 
    override func setUp() {
        categoryViewSpy = CategoryPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        categoryViewSpy = nil
    }
    
    // MARK: - Success
    func test_getCategoryList_successFully() {
        sut = CategoryPresenter(categoryService: CategoryServiceMock(true))
        sut.view = categoryViewSpy
        
        sut.getCategoryList()
        XCTAssertTrue(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteCategory_successfully() {
        sut = CategoryPresenter(categoryService: CategoryServiceMock(true))
        sut.view = categoryViewSpy
        
        sut.categories.append(PresenterFakeData.category)
        sut.deleteCategory(for: PresenterFakeData.category)
        XCTAssertTrue(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
    
    // MARK: - Failure
    func test_getCategoryList_failed() {
        sut = CategoryPresenter(categoryService: CategoryServiceMock(false))
        sut.view = categoryViewSpy
        
        sut.getCategoryList()
        XCTAssertFalse(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteCategory_failed() {
        sut = CategoryPresenter(categoryService: CategoryServiceMock(false))
        sut.view = categoryViewSpy
        
        sut.deleteCategory(for: PresenterFakeData.category)
        XCTAssertFalse(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
}

class CategoryPresenterViewSpy: CategoryPresenterView {
    var snapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    
    func applySnapshot(animatingDifferences: Bool) {
        snapshotWasCalled = true
    }
    
    func showActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
