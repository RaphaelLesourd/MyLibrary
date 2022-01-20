//
//  HomePresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class HomePresenterTestCase: XCTestCase {

    var sut: HomePresenter!

    override func tearDown() {
        sut = nil
    }
    
    // MARK: - Success
    func test_retreiveLatestBooks_thenReturnData() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(true),
                            categoryService: CategoryServiceMock(),
                            recommendationService: RecommendationServiceMock())
        // When
        sut.getLatestBooks()
        // Then
        XCTAssertEqual(sut.latestBooks.count, 1)
        XCTAssertEqual(sut.latestBooks[0].id, "testID")
    }

    func test_retreiveFavoriteBooks_thenReturnData() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(true),
                            categoryService: CategoryServiceMock(),
                            recommendationService: RecommendationServiceMock())
        // When
        sut.getFavoriteBooks()
        // Then
        XCTAssertEqual(sut.favoriteBooks.count, 1)
        XCTAssertEqual(sut.favoriteBooks[0].favorite, true)
    }

    func test_retreiveRecommendedBooks_thenReturnData() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(true),
                            categoryService: CategoryServiceMock(),
                            recommendationService: RecommendationServiceMock())
        // When
        sut.getRecommendations()
        // Then
        XCTAssertEqual(sut.recommandedBooks.count, 1)
        XCTAssertEqual(sut.recommandedBooks[0].id, "testID")
    }

    func test_retreiveCategories_thenReturnData() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(true),
                            categoryService: CategoryServiceMock(),
                            recommendationService: RecommendationServiceMock())
        // When
        sut.getCategories()
        // Then
        XCTAssertEqual(sut.categories.count, 1)
        XCTAssertEqual(sut.categories[0].name, "Test")
    }
    
    func test_retreiveUsers_thenReturnData() {
        // Given
        sut = HomePresenter(libraryService: LibraryServiceMock(true),
                            categoryService: CategoryServiceMock(),
                            recommendationService: RecommendationServiceMock())
        // When
        sut.getUsers()
        // Then
        XCTAssertEqual(sut.followedUser.count, 1)
        XCTAssertEqual(sut.followedUser[0].displayName, "TestUser")
    }
}
