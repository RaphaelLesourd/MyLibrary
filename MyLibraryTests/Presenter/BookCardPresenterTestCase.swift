//
//  BookCardPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 21/01/2022.
//

import XCTest
@testable import MyLibrary

class BookCardPresenterTestCase: XCTestCase {
    
    private var sut: BookCardPresenting!
    private var bookCardPresenterViewSpy: BookCardPresenterViewSpy!
    private let successTestPresenter = BookCardPresenter(libraryService: LibraryServiceMock(successTest: true),
                                                         recommendationService: RecommendationServiceMock(true),
                                                         categoryService: CategoryServiceMock(true),
                                                         formatter: Formatter(),
                                                         categoryFormatter: CategoriesFormatter())
    private let failedTestPresenter = BookCardPresenter(libraryService: LibraryServiceMock(successTest: false),
                                                        recommendationService: RecommendationServiceMock(false),
                                                        categoryService: CategoryServiceMock(false),
                                                        formatter: Formatter(),
                                                        categoryFormatter: CategoriesFormatter())
    
    override func setUp() {
        bookCardPresenterViewSpy = BookCardPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        bookCardPresenterViewSpy = nil
    }
    
    // MARK: - Success
    func test_DeletingBook_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.deleteBook()
        XCTAssertTrue(bookCardPresenterViewSpy.dismissControllerWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_updateBookRecommendStatus_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.updateStatus(state: true, documentKey: .recommanding)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_recommendBook_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.recommendBook(true)
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_removeBookFromRecommendation_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.recommendBook(false)
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_fetchBookUpdate_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.updateBook()
        XCTAssertTrue(bookCardPresenterViewSpy.displayBookWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_fetchCategoryNames_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.fetchCategoryNames()
        XCTAssertTrue(bookCardPresenterViewSpy.displayCategoriesWasCalled)
    }
    
    // MARK: - Fail
    func test_DeletingBook_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.deleteBook()
        XCTAssertFalse(bookCardPresenterViewSpy.dismissControllerWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_DeletingBook_whenNoBookIsPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.deleteBook()
        XCTAssertFalse(bookCardPresenterViewSpy.dismissControllerWasCalled)
        XCTAssertFalse(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_updateBookRecommendStatus_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.updateStatus(state: true, documentKey: .recommanding)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_updateBookRecommendStatus_whenNoBookPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.updateStatus(state: true, documentKey: .recommanding)
        XCTAssertFalse(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(bookCardPresenterViewSpy.stopActivityWasCalled)
    }

    func test_recommendBook_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.recommendBook(true)
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_removeBookFromRecommendation_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.recommendBook(false)
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_recommendBook_whenNoBookPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.recommendBook(true)
        XCTAssertFalse(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_removeBookFromRecommendation_whenNoBookPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.recommendBook(false)
        XCTAssertFalse(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_fetchBookUpdate_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = PresenterFakeData.book
        sut.updateBook()
        XCTAssertFalse(bookCardPresenterViewSpy.displayBookWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_fetchBookUpdate_whenNoBookPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.updateBook()
        XCTAssertFalse(bookCardPresenterViewSpy.displayBookWasCalled)
        XCTAssertFalse(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertFalse(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_fetchCategoryNames_whenNoBookPassed_failed() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.fetchCategoryNames()
        XCTAssertFalse(bookCardPresenterViewSpy.displayCategoriesWasCalled)
    }
}

class BookCardPresenterViewSpy: BookCardPresenterView {
   
 
    var dismissControllerWasCalled = false
    var playRecommendButtonIndicatorWasCalled = false
    var displayBookWasCalled = false
    var displayCategoriesWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    
    func displayBook(with data: BookCardRepresentable) {
        displayBookWasCalled = true
    }
    
    func displayCategories(with list: NSAttributedString) {
       displayCategoriesWasCalled = true
    }
    
    func dismissController() {
        dismissControllerWasCalled = true
    }
    
    func playRecommendButtonIndicator(_ play: Bool) {
        playRecommendButtonIndicatorWasCalled = true
    }
    
    func showActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
