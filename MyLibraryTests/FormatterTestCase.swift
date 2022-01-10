//
//  ConvertedTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 19/11/2021.
//

import XCTest
@testable import MyLibrary

class FormatterTestCase: XCTestCase {

    var sut: FormatterProtocol?
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = Formatter()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - tests
    func test_givenYearString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut?.formatDateToYearString(for: "1980-12-12")
        XCTAssertEqual(yearString, "1980")
    }
    
    func test_given4digitsString_whenConvertingToYearOnly_thenReturnOriginalInput() {
        let givenDateString = "2022"
        let yearString = sut?.formatDateToYearString(for: givenDateString)
        XCTAssertEqual(yearString, "2022")
    }
    
    func test_givenNilDateString_whenConvertingToYearOnly_thenReturnEmptyString() {
        let givenDateString = sut?.formatDateToYearString(for: nil)
        XCTAssertEqual(givenDateString, "")
    }
    
    func test_givenNotSupportedDateFormat_whenConvertingToYearOnly_thenReturnCurrentYear() {
        let givenDateString = "123123D/FSDF3423234"
        let yearString = sut?.formatDateToYearString(for: givenDateString)
        XCTAssertEqual(yearString, "")
    }
  
    func test_givenPriceAndCurrency_whenFormattingPrice_thenReturnPrice() {
        let currencyCode = "USD"
        let price = 21.5
        let itemPrice = sut?.formatDoubleToPrice(with: price, currencyCode: currencyCode)
        XCTAssertEqual(itemPrice, "$21.50")
    }
    
    func test_givenLanguageCode_whenConvertingToLanguageName_thenLanguageName() {
        let languageName = sut?.formatCodeToName(from: "fr", type: .language)
        XCTAssertEqual(languageName, "French")
    }
    
    func test_givenCurrencyCode_whenGettingLanguageName_thenReturnString() {
        let currencyName = sut?.formatCodeToName(from: "LTT", type: .currency)
        XCTAssertEqual(currencyName, "Lithuanian Talonas")
    }
    
    func test_givenTimesamp_whenFormattingToDate_thenReturnString() {
        XCTAssertEqual(sut?.formatTimeStampToRelativeDate(for: 123456767), "48 years ago")
    }

    func test_givenNilPriceAndCurrency_whenFormattingPrice_thenReturnPriceSetAtZero() {
        let currencyCode = "USD"
        let itemPrice = sut?.formatDoubleToPrice(with: nil, currencyCode: currencyCode)
        XCTAssertEqual(itemPrice, "$0")
    }
    
    func test_givenNilPriceAndNilCurrency_whenFormattingPrice_thenReturnPriceSetAtZeroWithDefaultEuroCurrency() {
        let itemPrice = sut?.formatDoubleToPrice(with: nil, currencyCode: nil)
        XCTAssertEqual(itemPrice, "€0")
    }
    
    func test_givenPriceAndNilCurrency_whenFormattingPrice_thenReturnPriceWithDefaultEuroCurrency() {
        let itemPrice = sut?.formatDoubleToPrice(with: 25, currencyCode: nil)
        XCTAssertEqual(itemPrice, "€25")
    }
    
    func test_givenNilLanguageCode_whenGettingLanguageName_returnEmptyString() {
        XCTAssertEqual(sut?.formatCodeToName(from: nil, type: .language), "")
    }
    
    func test_givenNonExistantLanguageCode_whenGettingLanguageName_returnEmptyString() {
        XCTAssertEqual(sut?.formatCodeToName(from: "eeeeeeeee", type: .language), "")
    }
    
    func test_givenNilCurrencyCode_whenGettingLanguageName_thenReturnEmptyString() {
        let currencyName = sut?.formatCodeToName(from: nil, type: .currency)
        XCTAssertEqual(currencyName, "")
    }
    
    func test_givenNonExistantCurrencyCode_whenGettingLanguageName_thenReturnEmptyString() {
        let currencyName = sut?.formatCodeToName(from: "123455", type: .currency)
        XCTAssertEqual(currencyName, "")
    }
    
    func test_givenNilTimestamp_whenFormattingToDate_thenReturnEmptyString() {
        XCTAssertEqual(sut?.formatTimeStampToRelativeDate(for: nil), "")
    }
}
