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
    private let successTestPresenter = NewBookPresenter(libraryService: LibraryServiceMock(successTest: true),
                                                        formatter: Formatter(),
                                                        converter: Converter(),
                                                        validator: Validation())
    private let failedTestPresenter = NewBookPresenter(libraryService: LibraryServiceMock(successTest: false),
                                                       formatter: Formatter(),
                                                       converter: Converter(),
                                                       validator: Validation())
    
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
        sut.book = PresenterFakeData.book
        sut.saveBook(with: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertTrue(newBookPresenterViewSpy.clearDataWasCalled)
    }
    
    func test_editingNewBook_successfull() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.isEditing = true
        sut.book = PresenterFakeData.book
        sut.saveBook(with: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertTrue(newBookPresenterViewSpy.returnToPreviousControllerWasCalled)
    }
    
    func test_whenSettingBookData_forDisplay() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.displayBook()
        XCTAssertTrue(newBookPresenterViewSpy.displayBookWasCalled)
        XCTAssertTrue(newBookPresenterViewSpy.updateLanguageViewWasCalled)
        XCTAssertTrue(newBookPresenterViewSpy.updateCurrencyViewWasCalled)
    }
    
    func test_whenSettingBookLanguage_withCode() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.setBookLanguage(with: "fr")
        XCTAssertTrue(newBookPresenterViewSpy.updateLanguageViewWasCalled)
    }
    
    func test_whenSettingBookCurrency_withCode() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.setBookCurrency(with: "USD")
        XCTAssertTrue(newBookPresenterViewSpy.updateCurrencyViewWasCalled)
    }
    
    // MARK: - Fail
    func test_savingNewBook_failed() {
        sut = failedTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.isEditing = false
        sut.book = PresenterFakeData.book
        sut.saveBook(with: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertFalse(newBookPresenterViewSpy.clearDataWasCalled)
    }
    
    func test_editingNewBook_failed() {
        sut = failedTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.isEditing = true
        sut.book = PresenterFakeData.book
        sut.saveBook(with: Data())
        XCTAssertTrue(newBookPresenterViewSpy.showSaveButtonIndicatorWasCalled)
        XCTAssertFalse(newBookPresenterViewSpy.clearDataWasCalled)
    }
    
    func test_whenSettingBookLanguage_withCodeNil() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.setBookLanguage(with: nil)
        XCTAssertFalse(newBookPresenterViewSpy.updateLanguageViewWasCalled)
    }
    
    func test_whenSettingBookCurrency_withCodeNil() {
        sut = successTestPresenter
        sut.view = newBookPresenterViewSpy
        sut.setBookCurrency(with: nil)
        XCTAssertFalse(newBookPresenterViewSpy.updateCurrencyViewWasCalled)
    }
}

class NewBookPresenterViewSpy: NewBookPresenterView {
    
    var displayBookWasCalled = false
    var updateLanguageViewWasCalled = false
    var updateCurrencyViewWasCalled = false
    var clearDataWasCalled = false
    var returnToPreviousControllerWasCalled = false
    var showSaveButtonIndicatorWasCalled = false
    
    func toggleSaveButtonActivityIndicator(to play: Bool) {
        showSaveButtonIndicatorWasCalled = true
    }
    
    func returnToPreviousVC() {
        returnToPreviousControllerWasCalled = true
    }
    
    func clearData() {
        clearDataWasCalled = true
    }
    
    func displayBook(with model: NewBookUI) {
        displayBookWasCalled = true
    }
    
    func displayLanguage(with language: String) {
        updateLanguageViewWasCalled = true
    }
    
    func displayCurrencyView(with currency: String) {
        updateCurrencyViewWasCalled = true
    }
}
