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
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.currentQuery =  FakeData.bookQuery
        sut.fetchBookList()
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.updateHeaderWasCalled)
    }

    func test_getBookListByCategory_withBooksReturned() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.currentQuery = FakeData.bookQueryByCategory
        sut.fetchBookList()
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.updateHeaderWasCalled)
    }

    func test_getBookList_noBooksReturned() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: false), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.currentQuery = FakeData.bookQuery
        sut.fetchBookList()
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.updateHeaderWasCalled)
    }

    func test_getBookList_withNilQuery() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.currentQuery = nil
        sut.fetchBookList()
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertFalse(libraryViewSpy.showActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.stopActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.updateHeaderWasCalled)
    }
    
    func test_makingBookCellUI() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        let book = sut.makeBookCellUI(for: FakeData.book)
        XCTAssertEqual(book.title, FakeData.book.volumeInfo?.title?.capitalized)
        XCTAssertEqual(book.image, FakeData.book.volumeInfo?.imageLinks?.thumbnail)
    }

    func test_updatingQueryType() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.currentQuery = FakeData.bookQuery
        sut.updateQuery(by: .title)
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.updateHeaderWasCalled)
    }

    func test_loadingMoreBooks_allConitionsAreMet_returnTrue() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.currentQuery = FakeData.bookQuery
        sut.endOfList = false
        sut.bookList = Array(repeating: FakeData.book, count: 40)
        sut.loadMoreBooks(currentIndex: 40, lastRow: 40)
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.updateHeaderWasCalled)
    }

    func test_loadingMoreBooks_whenWisibleRowEqualsCurrentIndex_andBookCountIsAtleastEqualToDatafetchlimit_returnFalse() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.endOfList = false
        sut.loadMoreBooks(currentIndex: 40, lastRow: 40)
        XCTAssertFalse(libraryViewSpy.snapshotWasCalled)
        XCTAssertFalse(libraryViewSpy.showActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.stopActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.updateHeaderWasCalled)
    }

    func test_loadingMoreBooks_whenEndOfListIsTrue_returnFalse() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy

        sut.endOfList = true
        sut.loadMoreBooks(currentIndex: 40, lastRow: 40)
        XCTAssertFalse(libraryViewSpy.snapshotWasCalled)
        XCTAssertFalse(libraryViewSpy.showActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.stopActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.updateHeaderWasCalled)
    }

    func test_loadingMoreBooks_whenCurrentIndexIsNotLastRow_returnFalse() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: true), queryService: QueryService())
        sut.view = libraryViewSpy
        sut.endOfList = false
        sut.loadMoreBooks(currentIndex: 4, lastRow: 40)
        XCTAssertFalse(libraryViewSpy.snapshotWasCalled)
        XCTAssertFalse(libraryViewSpy.showActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.stopActivityWasCalled)
        XCTAssertFalse(libraryViewSpy.updateHeaderWasCalled)
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
    
    func updateSectionTitle(with title: String) {
        updateHeaderWasCalled = true
    }
}
