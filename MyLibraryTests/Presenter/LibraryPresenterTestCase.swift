//
//  LibraryPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class LibraryPresenterTestCase: XCTestCase {

    private var sut: LibraryPresenter!
    private var libraryViewSpy: LibraryPresenterViewSpy!

    override func setUp() {
    libraryViewSpy = LibraryPresenterViewSpy()
    }
    
    override func tearDown() {
        sut = nil
        libraryViewSpy = nil
    }
    
    func test_getBookList_withBooksReturned() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true))
        sut.view = libraryViewSpy
        sut.getBooks(with: PresenterFakeData.bookQuery, nextPage: true)
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
    }

    func test_getBookList_noBooksReturned() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: false))
        sut.view = libraryViewSpy
        sut.getBooks(with: PresenterFakeData.bookQuery, nextPage: true)
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
    }
    
    func test_makingBookCellRepresentable() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true))
        let representable = sut.makeBookCellUI(for: PresenterFakeData.book)
        XCTAssertEqual(representable.title, PresenterFakeData.book.volumeInfo?.title?.capitalized)
        XCTAssertEqual(representable.image, PresenterFakeData.book.volumeInfo?.imageLinks?.thumbnail)
    }
}

class LibraryPresenterViewSpy: LibraryPresenterView {
    
    
    var snapshotWasCalled = false
    var showActivityWasCalled = false
    var stopActivityWasCalled = false
    var updateHeaderWasCalled = false
  
    func applySnapshot(animatingDifferences: Bool) {
        snapshotWasCalled = true
    }
    
    func startActivityIndicator() {
        showActivityWasCalled = true
    }
    
    func stopActivityIndicator() {
        stopActivityWasCalled = true
    }
    
    func updateSectionTitle(with title: String?) {
        updateHeaderWasCalled = true
    }
}
