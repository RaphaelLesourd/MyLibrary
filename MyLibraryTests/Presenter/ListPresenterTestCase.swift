//
//  ListPresenterTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 23/01/2022.
//

import XCTest
@testable import MyLibrary

class ListPresenterTestCase: XCTestCase {
    
    private var sut: ListPresenter!
    private var listPresenterViewSpy: ListPresenterViewSpy!
    private let languageTestPresenter = ListPresenter(listDataType: .languages, formatter: Formatter())
    private let currencyTestPresenter = ListPresenter(listDataType: .currency, formatter: Formatter())
    
    override func setUp() {
        listPresenterViewSpy = ListPresenterViewSpy()
    }
    override func tearDown() {
        sut = nil
        listPresenterViewSpy = nil
    }
    
    // MARK: - Tests
    func test_getData_successfully() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        XCTAssertTrue(listPresenterViewSpy.applySnapshotWasCalled)
    }
    
    func test_getContollerTitle() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getControllerTitle()
        XCTAssertTrue(listPresenterViewSpy.setTitleWasCalled)
    }
    
    func test_hightLightCell_whenLanguageDataReceived() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.selection = "FR"
        sut.highlightCell()
        XCTAssertTrue(listPresenterViewSpy.highlightCellWasCalled)
    }
    
    func test_hightLightCell_whenCurrencyDataReceived() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.selection = "USD"
        sut.highlightCell()
        XCTAssertTrue(listPresenterViewSpy.highlightCellWasCalled)
    }
    
    func test_sendLanguageData_whenCellSelected() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.saveSelection(from: FakeData.listData)
        XCTAssertTrue(listPresenterViewSpy.setLanguageWasCalled)
    }
    
    func test_sendCurrencyData_whenCellSelected() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.saveSelection(from: FakeData.listData)
        XCTAssertTrue(listPresenterViewSpy.setCurrencyWasCalled)
    }
    
    func test_sendData_whenDataPAssedIsNil() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.saveSelection(from: nil)
        XCTAssertFalse(listPresenterViewSpy.setCurrencyWasCalled)
    }
    
    func test_filteringData_whenSearchIsEmpty() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.filterList(with: "")
        XCTAssertTrue(listPresenterViewSpy.applySnapshotWasCalled)
    }
    
    func test_filteringData_whenSearchHasKeyword() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.filterList(with: "USD")
        XCTAssertTrue(listPresenterViewSpy.applySnapshotWasCalled)
    }

    func test_addingDataToFavoriteList() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.addToFavorite(with: FakeData.listData)
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewRowWasCalled)
    }
    
    func test_removeDataFromFavoriteList() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        print(sut.data[0])
        sut.favorites = ["XUA"]
        sut.removeFavorite(with: FakeData.listData)
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewRowWasCalled)
    }
}

class ListPresenterViewSpy: ListPresenterView {
   
    var setTitleWasCalled = false
    var highlightCellWasCalled = false
    var setLanguageWasCalled = false
    var setCurrencyWasCalled = false
    var reloadTableViewRowWasCalled = false
    var applySnapshotWasCalled = false
    
    func setTitle(as title: String) {
        setTitleWasCalled = true
    }
   
    func applySnapshot(animatingDifferences: Bool) {
        applySnapshotWasCalled = true
    }
    
    func reloadRow(for item: DataList) {
        reloadTableViewRowWasCalled = true
    }
    
    func setLanguage(with code: String) {
        setLanguageWasCalled = true
    }
    
    func setCurrency(with code: String) {
        setCurrencyWasCalled = true
    }
    
    func reloadTableViewRow(at indexPath: IndexPath) {
        reloadTableViewRowWasCalled = true
    }
    
    func highlightCell(for item: DataList) {
        highlightCellWasCalled = true
    }
}
