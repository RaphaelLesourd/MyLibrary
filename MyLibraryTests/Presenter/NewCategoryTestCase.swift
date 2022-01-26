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
        sut.setCategoryColor(with: "426db3")
        XCTAssertTrue(newCategoryPresenterViewSpy.updateCategoryColorWasCalled)
    }
    
    func test_savingCategory_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.isEditing = false
        sut.saveCategory(with: "test", and: "AAAAA", for: PresenterFakeData.category)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_updatingCategory_successfully() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.isEditing = true
        sut.saveCategory(with: "test", and: "AAAAA", for: PresenterFakeData.category)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    // MARK: - Failed
    func test_setCategoryColor_withHexColorString_NoTPartOfDefaultColor() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.setCategoryColor(with: "AAAAAA")
        XCTAssertFalse(newCategoryPresenterViewSpy.updateCategoryColorWasCalled)
    }
    
    func test_setCategoryColor_withNilHexColorString() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.setCategoryColor(with: nil)
        XCTAssertFalse(newCategoryPresenterViewSpy.updateCategoryColorWasCalled)
    }
    
    func test_savingCategory_withNoCategoryName() {
        sut = successTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.isEditing = false
        sut.saveCategory(with: nil, and: "AAAAA", for: PresenterFakeData.category)
        XCTAssertFalse(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_savingCategory_failed() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.isEditing = false
        sut.saveCategory(with: "test", and: "AAAAA", for: PresenterFakeData.category)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_updatingCategory_withNoCategoryName() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.isEditing = true
        sut.saveCategory(with: nil, and: "AAAA", for: PresenterFakeData.category)
        XCTAssertTrue(newCategoryPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(newCategoryPresenterViewSpy.stopActivityWasCalled)
        XCTAssertFalse(newCategoryPresenterViewSpy.dismissViewcontrollerWasCalled)
    }
    
    func test_updatingCategory_withNilCategory() {
        sut = failTestPresenter
        sut.view = newCategoryPresenterViewSpy
        sut.isEditing = true
        sut.saveCategory(with: nil, and: "AAAA", for: nil)
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
    
    func showActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
    
    
}
