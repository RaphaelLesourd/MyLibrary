//
//  NewCategoryTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 24/01/2022.
//

import XCTest
@testable import MyLibrary

class NewCategoryTestCase: XCTestCase {
    
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
    func test_setCategoryColor_withHexColorString() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.displayCategoryColor(with: "426db3")
        XCTAssertTrue(newCategoryPresenterViewSpy.updateCategoryColorWasCalled)
    }
    
    func test_savingCategory_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: "test", and: "AAAAA", for: PresenterFakeData.category)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_withCategoryModelToPass_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: "test", and: "AAAAA", for: nil)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_updatingCategory_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: "test", and: "AAAAA", for: PresenterFakeData.category)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    // MARK: - Failed
    func test_setCategoryColor_withHexColorString_NoTPartOfDefaultColor() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.displayCategoryColor(with: "AAAAAA")
        XCTAssertFalse(newCategoryPresenterViewSpy.updateCategoryColorWasCalled)
    }
    
    func test_setCategoryColor_withNilHexColorString() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.displayCategoryColor(with: nil)
        XCTAssertFalse(newCategoryPresenterViewSpy.updateCategoryColorWasCalled)
    }
    
    func test_savingCategory_withCategoryModelToPass_withNoCategoryName() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: nil, and: "AAAAA", for: nil)
        XCTAssertFalse(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_withCategoryModelToPass_failed() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: "test", and: "AAAAA", for: nil)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_failed() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: "test", and: "AAAAA", for: PresenterFakeData.category)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_withNoCategoryName() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.saveCategory(with: nil, and: "AAAA", for: PresenterFakeData.category)
        XCTAssertFalse(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
}

class NewCategoryPresenterViewSpy: NewCategoryPresenterView {
    
    var updateCategoryColorWasCalled = false
    var dismissViewcontrollerWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    
    func updateCategoryColor(at indexPath: IndexPath, and colorHex: String) {
        updateCategoryColorWasCalled = true
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
