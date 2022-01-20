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
        sut.getBooks(with: PresenterFakeData.bookQuery)
        XCTAssertFalse(libraryViewSpy.snapshotWasCalled)
        XCTAssertTrue(libraryViewSpy.addToBookListCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
    }

    func test_getBookList_noBooksReturned() {
        sut = LibraryPresenter(libraryService: LibraryServiceMock(successTest: false))
        sut.view = libraryViewSpy
        sut.getBooks(with: PresenterFakeData.bookQuery)
        XCTAssertTrue(libraryViewSpy.snapshotWasCalled)
        XCTAssertFalse(libraryViewSpy.addToBookListCalled)
        XCTAssertTrue(libraryViewSpy.showActivityWasCalled)
        XCTAssertTrue(libraryViewSpy.stopActivityWasCalled)
    }
}

class LibraryPresenterViewSpy: LibraryPresenterView {
    
    var addToBookListCalled = false
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
    
    func addBookToList(_ books: [Item]) {
        addToBookListCalled = true
    }
    
}
