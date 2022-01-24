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
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewWasCalled)
    }
    
    func test_getContollerTitle() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getControllerTitle()
        XCTAssertTrue(listPresenterViewSpy.setTitleWasCalled)
    }
    
    func test_getSectionTitle() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getSectionTitle()
        XCTAssertTrue(listPresenterViewSpy.setSectionTitleWasCalled)
    }
    
    func test_hightLightCell_whenLanguageDataReceived() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.receivedData = "FR"
        sut.highlightCell()
        XCTAssertTrue(listPresenterViewSpy.highlightCellWasCalled)
    }
    
    func test_hightLightCell_whenCurrencyDataReceived() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.receivedData = "USD"
        sut.highlightCell()
        XCTAssertTrue(listPresenterViewSpy.highlightCellWasCalled)
    }
    
    func test_sendLangugeData_whenCellSelected() {
        sut = languageTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.getSelectedData(at: 0)
        XCTAssertTrue(listPresenterViewSpy.setLanguageWasCalled)
    }
    
    func test_sendCurrencyData_whenCellSelected() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.getSelectedData(at: 0)
        XCTAssertTrue(listPresenterViewSpy.setCurrencyWasCalled)
    }
    
    func test_filteringData_whenSearchIsEmpty() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.filterList(with: "")
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewWasCalled)
    }
    
    func test_filteringData_whenSearchHasKeyword() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.filterList(with: "USD")
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewWasCalled)
    }
    
    func test_getFavoritesList() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getFavorites()
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewWasCalled)
    }
    
    func test_addingDataToFavoriteList() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        sut.addToFavorite(for: 0)
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewRowWasCalled)
    }
    
    func test_removeDataFromFavoriteList() {
        sut = currencyTestPresenter
        sut.view = listPresenterViewSpy
        sut.getData()
        print(sut.data[0])
        sut.favorites = ["XUA"]
        sut.removeFavorite(at: 0)
        XCTAssertTrue(listPresenterViewSpy.reloadTableViewRowWasCalled)
    }
    
}

class ListPresenterViewSpy: ListPresenterView {
    
    var setTitleWasCalled = false
    var setSectionTitleWasCalled = false
    var highlightCellWasCalled = false
    var reloadTableViewWasCalled = false
    var setLanguageWasCalled = false
    var setCurrencyWasCalled = false
    var reloadTableViewRowWasCalled = false
    
    func setTitle(as title: String) {
        setTitleWasCalled = true
    }
    
    func setSectionTitle(as title: String) {
        setSectionTitleWasCalled = true
    }
    
    func highlightCell(at indexPath: IndexPath) {
        highlightCellWasCalled = true
    }
    
    func reloadTableView() {
        reloadTableViewWasCalled = true
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
}
