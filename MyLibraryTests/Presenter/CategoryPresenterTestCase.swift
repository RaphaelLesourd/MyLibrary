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
    private let successTestPresenter = CategoryPresenter(categoryService: CategoryServiceMock(true))
    private let failedTestPresenter = CategoryPresenter(categoryService: CategoryServiceMock(false))
    
    override func setUp() {
        categoryViewSpy = CategoryPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        categoryViewSpy = nil
    }
    
    // MARK: - Success
    func test_getCategoryList_successFully() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        
        sut.getCategoryList()
        XCTAssertTrue(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteCategory_successfully() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categories.append(PresenterFakeData.category)
        sut.deleteCategory(for: PresenterFakeData.category)
        XCTAssertTrue(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
    
    func test_searchForCategory_searchTextIsEmpty() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.filterSearchedCategories(for: "")
        XCTAssertTrue(categoryViewSpy.snapshotWasCalled)
    }
    
    func test_searchForCategory_searchTextHasContent() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categoriesOriginalList = PresenterFakeData.categories
        sut.filterSearchedCategories(for: "First")
        XCTAssertTrue(categoryViewSpy.snapshotWasCalled)
    }
    
    func test_highLightCell_whenCategoryExist() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categories = PresenterFakeData.categories
        sut.selectedCategories = ["1"]
        sut.highlightBookCategories(for: 0)
        XCTAssertTrue(categoryViewSpy.highLightCellWasCalled)
    }
    
    func test_swipingCellAction_whenDeleting() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categories = PresenterFakeData.categories
        sut.presentSwipeAction(for: .delete, at: 0)
        XCTAssertTrue(categoryViewSpy.displayDeleteAlertWasCalled)
    }
    
    func test_swipingCellAction_whenEdit() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categories = PresenterFakeData.categories
        sut.presentSwipeAction(for: .edit, at: 0)
        XCTAssertTrue(categoryViewSpy.presentNewCategoryControllerWasCalled)
    }
    
    func test_addCategoryFromCategories_toSelectedCategories() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categories = PresenterFakeData.categories
        sut.addSelectedCategory(at: 0)
        XCTAssertEqual(sut.selectedCategories.count, 1)
    }
    
    func test_removeCategoryFromSelectedCategories() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categories = PresenterFakeData.categories
        sut.selectedCategories = ["1"]
        sut.removeSelectedCategory(from: 0)
        XCTAssertEqual(sut.selectedCategories.count, 0)
    }
    // MARK: - Failure
    func test_getCategoryList_failed() {
        sut = failedTestPresenter
        sut.view = categoryViewSpy
        
        sut.getCategoryList()
        XCTAssertFalse(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
    
    func test_deleteCategory_failed() {
        sut = failedTestPresenter
        sut.view = categoryViewSpy
        
        sut.deleteCategory(for: PresenterFakeData.category)
        XCTAssertFalse(categoryViewSpy.snapshotWasCalled)
        XCTAssertTrue(categoryViewSpy.showActivityWasCalled)
        XCTAssertTrue(categoryViewSpy.stopActivityWasCalled)
    }
    
    func test_highLightCell_whenCategoryDoNotExist() {
        sut = successTestPresenter
        sut.view = categoryViewSpy
        sut.categories = PresenterFakeData.categories
        sut.selectedCategories = ["34"]
        sut.highlightBookCategories(for: 0)
        XCTAssertFalse(categoryViewSpy.highLightCellWasCalled)
    }
}

class CategoryPresenterViewSpy: CategoryPresenterView {

    var highLightCellWasCalled = false
    var displayDeleteAlertWasCalled = false
    var presentNewCategoryControllerWasCalled = false
    var snapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    
    func highlightCell(at indexPath: IndexPath) {
        highLightCellWasCalled = true
    }
    
    func displayDeleteAlert(for category: CategoryDTO) {
        displayDeleteAlertWasCalled = true
    }
    
    func presentNewCategoryController(with category: CategoryDTO?) {
        presentNewCategoryControllerWasCalled = true
    }
    
    func applySnapshot(animatingDifferences: Bool) {
        snapshotWasCalled = true
    }
    
    func startActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
