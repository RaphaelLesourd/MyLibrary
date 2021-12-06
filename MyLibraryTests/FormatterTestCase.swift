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

    // MARK: - Success tests
    func test_givenArrayOfString_whenJoining_thenReturnString() {
        let stringArray = ["One", "Two", "Three", "Four", "Five"]
        let string = sut?.joinArrayToString(stringArray)
        XCTAssertEqual(string, "One, Two, Three, Four, Five")
    }
    
    func givenYearString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut?.formatDateToYearString(for: "1980-12-12")
        XCTAssertEqual(yearString, "1980")
    }

    func givenDecimalStringWithComma_whenConvertingToDouble_returnDouble() {
        let decimalString = "25,5"
        XCTAssertEqual(sut?.formatDecimalString(decimalString), 25.5)
    }
    
    func givenDecimalStringWithPeriod_whenConvertingToDouble_thenReturnDouble() {
        let decimalString = "2.5"
        XCTAssertEqual(sut?.formatDecimalString(decimalString), 2.5)
    }
    
    func test_givenString_whenConvertToInt_thenReturnInt() {
        let value = "1234"
        XCTAssertEqual(sut?.formatStringToInt(value), 1234)
    }
    
    func test_givenPriceAndCurrency_whenFormattingPrice_thenReturnPrice() {
        let currencyCode = "USD"
        let price = 21.5
        let itemPrice = sut?.formatCurrency(with: price, currencyCode: currencyCode)
        XCTAssertEqual(itemPrice, "$21.5")
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
        XCTAssertEqual(sut?.formatTimeStampToDateString(for: 123456767), "Nov 29, 1973 at 10:32 PM")
    }
    // MARK: - Failure tests
    func test_givenNilArray_whenJoining_thenReturnEmptyString() {
        let string = sut?.joinArrayToString(nil)
        XCTAssertEqual(string, "")
    }
    
    func test_givenNilDateString_whenConvertingToYearOnly_thenReturnEmptyString() {
        let givenDateString = sut?.formatDateToYearString(for: nil)
        XCTAssertEqual(givenDateString, "")
    }
    
    func test_givenNotSupportedDateFormat_whenConvertingToYearOnly_thenReturnCurrentYear() {
        let givenDateString = "123123D/FSDF3423234"
        let yearString = sut?.formatDateToYearString(for: givenDateString)
        XCTAssertEqual(yearString, "2021")
    }
    
    func test_givenNilDecimalString_whenConvertingToDouble_thenReturnZero() {
        XCTAssertEqual(sut?.formatDecimalString(nil), 0)
    }
    
    func test_givenStringWithLetter_whenConvertingToDouble_thenReturnZero() {
        XCTAssertEqual(sut?.formatDecimalString("abcde"), 0)
    }
    
    
    func test_givenStringWithLetters_whenConvertingToInt_thenReturnZero() {
        let value = "AZERTY"
        XCTAssertEqual(sut?.formatStringToInt(value), 0)
    }
    
    func test_givenNilString_whenConvertingToInt_thenReturnZero() {
        XCTAssertEqual(sut?.formatStringToInt(nil), 0)
    }
    
    func test_givenNilPriceAndCurrency_whenFormattingPrice_thenReturnPriceSetAtZero() {
        let currencyCode = "USD"
        let itemPrice = sut?.formatCurrency(with: nil, currencyCode: currencyCode)
        XCTAssertEqual(itemPrice, "$0")
    }
    
    func test_givenNilPriceAndNilCurrency_whenFormattingPrice_thenReturnPriceSetAtZeroWithDefaultEuroCurrency() {
        let itemPrice = sut?.formatCurrency(with: nil, currencyCode: nil)
        XCTAssertEqual(itemPrice, "€0")
    }
    
    func test_givenPriceAndNilCurrency_whenFormattingPrice_thenReturnPriceWithDefaultEuroCurrency() {
        let itemPrice = sut?.formatCurrency(with: 25, currencyCode: nil)
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
        XCTAssertEqual(sut?.formatTimeStampToDateString(for: nil), "")
    }
}
