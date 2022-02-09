//
//  BookCardPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 21/01/2022.
//

import XCTest
@testable import MyLibrary

class BookCardPresenterTestCase: XCTestCase {
    
    private var sut: BookCardPresenter!
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
        sut.book = FakeData.book
        sut.deleteBook()
        XCTAssertTrue(bookCardPresenterViewSpy.dismissControllerWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_updateBookRecommendStatus_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.updateStatus(state: true, documentKey: .recommanding)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_recommendBook_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.recommendBook()
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_removeBookFromRecommendation_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.recommended = false
        sut.recommendBook()
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_fetchBookUpdate_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.fetchBookUpdate()
        XCTAssertTrue(bookCardPresenterViewSpy.displayBookWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_fetchCategoryNames_successFully() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.fetchCategoryNames()
        XCTAssertTrue(bookCardPresenterViewSpy.displayCategoriesWasCalled)
    }

    func test_isBookEditable_withConnection_andCurrentUserID_returnTrue() {
         sut = successTestPresenter
         sut.view = bookCardPresenterViewSpy
         sut.book = FakeData.book
         sut.currentUserID = "1"
         Networkconnectivity.shared.status = .satisfied
         XCTAssertTrue(sut.isBookEditable)
     }
    
    // MARK: - Fail
    func test_DeletingBook_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
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
        sut.book = FakeData.book
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
        sut.book = FakeData.book
        sut.recommendBook()
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_removeBookFromRecommendation_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.recommended = false
        sut.recommendBook()
        XCTAssertTrue(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_recommendBook_whenNoBookPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.recommendBook()
        XCTAssertFalse(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_removeBookFromRecommendation_whenNoBookPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.recommendBook()
        XCTAssertFalse(bookCardPresenterViewSpy.playRecommendButtonIndicatorWasCalled)
    }
    
    func test_fetchBookUpdate_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.fetchBookUpdate()
        XCTAssertTrue(bookCardPresenterViewSpy.showActivityWasCalled)
        XCTAssertTrue(bookCardPresenterViewSpy.stopActivityWasCalled)
    }
    
    func test_fetchBookUpdate_whenNoBookPassed_failed() {
        sut = failedTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.fetchBookUpdate()
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


    func test_isBookEditable_withNotcurrentUserID_returnFalse() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.currentUserID = "12"
        Networkconnectivity.shared.status = .satisfied
        XCTAssertFalse(sut.isBookEditable)
    }

    func test_isBookEditable_withNotConnection_andCurrentUserID_returnFalse() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.currentUserID = "1"
        Networkconnectivity.shared.status = .unsatisfied
        XCTAssertFalse(sut.isBookEditable)
    }
   func test_isBookEditable_withNotConnection_andNotCurrentUserID_returnFalse() {
        sut = successTestPresenter
        sut.view = bookCardPresenterViewSpy
        sut.book = FakeData.book
        sut.currentUserID = "12"
        Networkconnectivity.shared.status = .unsatisfied
        XCTAssertFalse(sut.isBookEditable)
    }

    func test_isBookEditable_withConnection_andNotCurrentUserID_returnFalse() {
         sut = successTestPresenter
         sut.view = bookCardPresenterViewSpy
         sut.book = FakeData.book
         sut.currentUserID = "12"
         Networkconnectivity.shared.status = .satisfied
         XCTAssertFalse(sut.isBookEditable)
     }
}

class BookCardPresenterViewSpy: BookCardPresenterView {


    var dismissControllerWasCalled = false
    var playRecommendButtonIndicatorWasCalled = false
    var displayBookWasCalled = false
    var displayCategoriesWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    var toggleRecommendButtonwasCalled = false
    var toggleFavoriteButtonWasCalled = false

    func toggleRecommendButton(as recommended: Bool) {
        toggleRecommendButtonwasCalled = true
    }

    func toggleFavoriteButton(as favorite: Bool) {
        toggleFavoriteButtonWasCalled = true
    }

    func displayBook(with data: BookCardUI) {
        displayBookWasCalled = true
    }
    
    func displayCategories(with list: NSAttributedString) {
        displayCategoriesWasCalled = true
    }
    
    func dismissController() {
        dismissControllerWasCalled = true
    }
    
    func toggleRecommendButtonIndicator(on play: Bool) {
        playRecommendButtonIndicatorWasCalled = true
    }
    
    func startActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
}
