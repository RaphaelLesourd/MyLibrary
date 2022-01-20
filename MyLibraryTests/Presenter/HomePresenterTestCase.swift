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
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: true),
                            categoryService: CategoryServiceMock(true),
                            recommendationService: RecommendationServiceMock(true))
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
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: true),
                            categoryService: CategoryServiceMock(true),
                            recommendationService: RecommendationServiceMock(true))
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
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: true),
                            categoryService: CategoryServiceMock(true),
                            recommendationService: RecommendationServiceMock(true))
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
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: true),
                            categoryService: CategoryServiceMock(true),
                            recommendationService: RecommendationServiceMock(true))
        sut.view = homeViewSpy
        // When
        sut.getCategories()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
    }
    
    func test_retreiveUsers_thenReturnData() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: true),
                            categoryService: CategoryServiceMock(true),
                            recommendationService: RecommendationServiceMock(true))
        sut.view = homeViewSpy
        // When
        sut.getUsers()
        // Then
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
    }
    
    // MARK: - Fail
    func test_whenRetreivecategoriesAndErrorOccurs_thenReturnNoUser() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: false),
                            categoryService: CategoryServiceMock(false),
                            recommendationService: RecommendationServiceMock(false))
        sut.view = homeViewSpy
        // When
        sut.getCategories()
        // Then
        XCTAssertFalse(homeViewSpy.snapshotWasCalled)
    }
    
    func test_whenRetreiveLatestBooksAndErrorOccurs_thenNoBooks() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: false),
                            categoryService: CategoryServiceMock(false),
                            recommendationService: RecommendationServiceMock(false))
        sut.view = homeViewSpy
        // When
        sut.getLatestBooks()
        XCTAssertTrue(homeViewSpy.snapshotWasCalled)
        XCTAssertTrue(homeViewSpy.showActivityWasCalled)
        XCTAssertTrue(homeViewSpy.stopActivityWasCalled)
    }
    
    func test_whenRetreiveFavoriteBooksAndErrorOccurs_thenReturnNoBooks() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: false),
                            categoryService: CategoryServiceMock(false),
                            recommendationService: RecommendationServiceMock(false))
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
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: false),
                            categoryService: CategoryServiceMock(false),
                            recommendationService: RecommendationServiceMock(false))
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
        sut = HomePresenter(libraryService: LibraryServiceMock(successTest: false),
                            categoryService: CategoryServiceMock(false),
                            recommendationService: RecommendationServiceMock(false))
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
