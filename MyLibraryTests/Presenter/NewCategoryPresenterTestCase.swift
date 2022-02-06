//
//  NewCategoryTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 24/01/2022.
//

import XCTest
@testable import MyLibrary

class NewCategoryPresenterTestCase: XCTestCase {
    
    private var sut: NewCategoryPresenter!
    private var newCategoryPresenterViewSpy: NewCategoryPresenterViewSpy!
    private let successTestPresenter = NewCategoryPresenter(categoryService: CategoryServiceMock(true))
    private let failTestPresenter = NewCategoryPresenter(categoryService: CategoryServiceMock(false))
    
    override func setUp() {
        newCategoryPresenterViewSpy = NewCategoryPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        newCategoryPresenterViewSpy = nil
    }
    
    // MARK: - Succes
    func test_displayCategory() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.category = FakeData.category
        sut.displayCategory()
        XCTAssertTrue(newCategoryPresenterViewSpy.updateCategoryWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.updateBackgroundTintWasCalled)
    }
    
    func test_savingCategory_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: "test")
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_withCategoryModelToPass_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: "test")
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_updatingCategory_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.category = FakeData.category
        sut.saveCategory(with: "test")
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    // MARK: - Failed
    func test_setCategory_withNilCategory() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.displayCategory()
        XCTAssertFalse(newCategoryPresenterViewSpy.updateCategoryWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.updateBackgroundTintWasCalled)
    }
    
    func test_savingCategory_withCategoryModelToPass_withNoCategoryName() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.category = nil
        sut.saveCategory(with: nil)
        XCTAssertFalse(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_withCategoryModelToPass_failed() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.category = nil
        sut.saveCategory(with: "test")
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_failed() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.category = FakeData.category
        sut.saveCategory(with: "test")
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_withNoCategoryName() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.category = FakeData.category
        sut.saveCategory(with: nil)
        XCTAssertFalse(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
}

class NewCategoryPresenterViewSpy: NewCategoryPresenterView {
  
    var updateCategoryWasCalled = false
    var updateBackgroundTintWasCalled = false
    var dismissViewcontrollerWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    
    func updateCategory(at indexPath: IndexPath, color: String, name: String) {
        updateCategoryWasCalled = true
    }

    func updateBackgroundTint(with colorHex: String) {
        updateBackgroundTintWasCalled = true
    }
    
    func dismissViewController() {
        dismissViewcontrollerWasCalled = true
    }
    
    func startActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
    
    
}
