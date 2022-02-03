//
//  HomePresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class HomePresenterTestCase: XCTestCase {

    private var sut: HomePresenter!
    private var homeViewSpy: HomeViewSpy!
    private let successTestPresenter = HomePresenter(libraryService: LibraryServiceMock(successTest: true),
                                                     categoryService: CategoryServiceMock(true),
                                                     recommendationService: RecommendationServiceMock(true))
    private let failedTestPresenter = HomePresenter(libraryService: LibraryServiceMock(successTest: false),
                                                    categoryService: CategoryServiceMock(false),
                                                    recommendationService: RecommendationServiceMock(false))
    
    override func setUp() {
        homeViewSpy = HomeViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        homeViewSpy = nil
    }
    
    // MARK: - Success
    func test_retreiveLatestBooks_thenReturnData() {
        // Given
        sut = successTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getLatestBooks()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
        XCTAssertTrue(homeViewSpy.showActivityWasCalled)
        XCTAssertTrue(homeViewSpy.stopActivityWasCalled)
    }

    func test_retreiveFavoriteBooks_thenReturnData() {
        // Given
        sut = successTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getFavoriteBooks()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
        XCTAssertTrue(homeViewSpy.showActivityWasCalled)
        XCTAssertTrue(homeViewSpy.stopActivityWasCalled)
    }

    func test_retreiveRecommendedBooks_thenReturnData() {
        // Given
        sut = successTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getRecommendations()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
        XCTAssertTrue(homeViewSpy.showActivityWasCalled)
        XCTAssertTrue(homeViewSpy.stopActivityWasCalled)
    }

    func test_retreiveCategories_thenReturnData() {
        // Given
        sut = successTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getCategories()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
    }
    
    func test_retreiveUsers_thenReturnData() {
        // Given
        sut = successTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getUsers()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
    }

    func test_makeUserCellUI_fromUserModelDTO_whenUserIsCurrentUser() {
        sut = successTestPresenter
        sut.view = homeViewSpy
        sut.currentUserID = "1111"
        let userCellUI = sut.makeUserCellUI(with: PresenterFakeData.user)
        XCTAssertTrue(userCellUI.currentUser)
        XCTAssertEqual(userCellUI.profileImage, "PhotoURL")
        XCTAssertEqual(userCellUI.userName, "Testname")
    }

    func test_makeUserCellUI_fromUserModelDTO_whenUserIsNotCurrentUser() {
        sut = successTestPresenter
        sut.view = homeViewSpy
        sut.currentUserID = "0000"
        let userCellUI = sut.makeUserCellUI(with: PresenterFakeData.user)
        XCTAssertFalse(userCellUI.currentUser)
        XCTAssertEqual(userCellUI.profileImage, "PhotoURL")
        XCTAssertEqual(userCellUI.userName, "Testname")
    }

    func test_displayItem_whenSelectedItemIsCategory() {
        sut = successTestPresenter
        sut.view = homeViewSpy
        sut.displayItem(for: PresenterFakeData.category)
        XCTAssertTrue(homeViewSpy.presentBookLibraycontrollerWasCalled)
    }

    func test_displayItem_whenSelectedItemisBookItem() {
        sut = successTestPresenter
        sut.view = homeViewSpy
        sut.displayItem(for: PresenterFakeData.book)
        XCTAssertTrue(homeViewSpy.presentBookCardControllerWasCalled)
    }

    func test_displayItem_whenSelectedItemIsUser() {
        sut = successTestPresenter
        sut.view = homeViewSpy
        sut.displayItem(for: PresenterFakeData.user)
        XCTAssertTrue(homeViewSpy.presentBookLibraycontrollerWasCalled)
    }

    // MARK: - Fail
    func test_whenRetreivecategoriesAndErrorOccurs_thenReturnNoUser() {
        // Given
        sut = failedTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getCategories()
        // Then
        XCTAssertFalse(homeViewSpy.snapshotWasCalled)
    }
    
    func test_whenRetreiveLatestBooksAndErrorOccurs_thenNoBooks() {
        // Given
        sut = failedTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getLatestBooks()
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
        XCTAssertTrue(homeViewSpy.showActivityWasCalled)
        XCTAssertTrue(homeViewSpy.stopActivityWasCalled)
    }
    
    func test_whenRetreiveFavoriteBooksAndErrorOccurs_thenReturnNoBooks() {
        // Given
        sut = failedTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getFavoriteBooks()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
        XCTAssertTrue(homeViewSpy.showActivityWasCalled)
        XCTAssertTrue(homeViewSpy.stopActivityWasCalled)
    }
    
    func test_whenRetreiveRecommendedBooksAndErrorOccurs_thenReturnNoBooks() {
        // Given
        sut = failedTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getRecommendations()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
        XCTAssertTrue(homeViewSpy.showActivityWasCalled)
        XCTAssertTrue(homeViewSpy.stopActivityWasCalled)
    }
    
    func test_whenRetreiveUsersAndErrorOccurs_thenReturnNoUser() {
        // Given
        sut = failedTestPresenter
        sut.view = homeViewSpy
        // When
        sut.getUsers()
        // Then
        XCTAssertFalse(homeViewSpy.snapshotWasCalled)
    }
        
}

class HomeViewSpy: HomePresenterView {

    var snapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    var presentBookLibraycontrollerWasCalled = false
    var presentBookCardControllerWasCalled = false

    func presentBookLibraryController(for query: BookQuery?, title: String?) {
        presentBookLibraycontrollerWasCalled = true
    }

    func presentBookCardController(with book: ItemDTO) {
        presentBookCardControllerWasCalled = true
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
