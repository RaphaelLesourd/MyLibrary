//
//  NewBookPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 21/01/2022.
//

import XCTest
@testable import MyLibrary

class NewBookPresenterTestCase: XCTestCase {
    
    private var sut: NewBookPresenter!
    private var newBookPresenterViewSpy: NewBookPresenterViewSpy!
    private let successTestPresenter = NewBookPresenter(libraryService: LibraryServiceMock(successTest: true))
    private let failedTestPresenter = NewBookPresenter(libraryService: LibraryServiceMock(successTest: false))
    
    override func setUp() {
        newBookPresenterViewSpy = NewBookPresenterViewSpy()
    }
    override func tearDown() {
        sut = nil
        newBookPresenterViewSpy = nil
    }
    
    // MARK: - Success
    func test_savingNewBook_successfull() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.isEditing = false
        sut.saveBook(with: PresenterFakeData.book, and: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertTrue(newBookPresenterViewSpy.clearDataWasCalled)
    }
    
    func test_editingNewBook_successfull() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.isEditing = true
        sut.saveBook(with: PresenterFakeData.book, and: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertTrue(newBookPresenterViewSpy.returnToPreviousControllerWasCalled)
    }
    
    // MARK: - Fail
    func test_savingNewBook_failed() {
        sut = failedTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.isEditing = false
        sut.saveBook(with: PresenterFakeData.book, and: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertFalse(newBookPresenterViewSpy.clearDataWasCalled)
    }
    
    func test_editingNewBook_failed() {
        sut = failedTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.isEditing = true
        sut.saveBook(with: PresenterFakeData.book, and: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertFalse(newBookPresenterViewSpy.clearDataWasCalled)
    }
}

class NewBookPresenterViewSpy: NewBookPresenterView {
    var clearDataWasCalled = false
    var returnToPreviousControllerWasCalled = false
    var showSaveButtonIndicatorWasCalled = false
    
    func showSaveButtonActicityIndicator(_ show: Bool) {
        showSaveButtonIndicatorWasCalled = true
    }
    
    func returnToPreviousController() {
        returnToPreviousControllerWasCalled = true
    }
    
    func clearData() {
        clearDataWasCalled = true
    }
}
