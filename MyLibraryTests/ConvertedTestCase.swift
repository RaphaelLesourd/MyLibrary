//
//  ConvertedTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 19/11/2021.
//

import XCTest

@testable import MyLibrary

class ConvertedTestCase: XCTestCase {

    var sut: Converter!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = Converter()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Success tests
    func test_givenArrayOfString_whenJoining_thenReturnString() {
        let stringArray = ["One", "Two", "Three", "Four", "Five"]
        let string = sut.joinArrayToString(stringArray)
        XCTAssertEqual(string, "One, Two, Three, Four, Five")
    }
    
    func givenYearString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut.displayYearOnly(for: "1980")
        XCTAssertEqual(yearString, "1980")
    }
    
    func givenYearMonthDayString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut.displayYearOnly(for: "1980-12-12")
        XCTAssertEqual(yearString, "1980")
    }
    
    func givenYearMonthDayWithTimeString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut.displayYearOnly(for: "1980-12-12 12:00:00")
        XCTAssertEqual(yearString, "1980")
    }
    
    func givenYearMonthDayWithTimeAndOneDigitMilisecTimezoneString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut.displayYearOnly(for: "2014-12-03T10:05:59.5+08:00")
        XCTAssertEqual(yearString, "2014")
    }
    
    func givenYearMonthDayWithTimeAndTwoDigitMilisecTimezoneString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut.displayYearOnly(for: "2014-12-03T10:05:59.55+08:00")
        XCTAssertEqual(yearString, "2014")
    }
    
    func givenYearMonthDayWithTimeAndThreeDigitMilisecTimezoneString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut.displayYearOnly(for: "2014-12-03T10:05:59.555+08:00")
        XCTAssertEqual(yearString, "2014")
    }
    
    func givenYearMonthDayWithTimeAndFourDigitMilisecTimezoneString_whenConvertingToYearOnly_thenReturnYearStringWith4digits() {
        let yearString = sut.displayYearOnly(for: "2014-12-03T10:05:59.5555+08:00")
        XCTAssertEqual(yearString, "2014")
    }
    
    func givenDecimalStringWithComma_whenConvertingToDouble_returnDouble() {
        let decimalString = "25,5"
        XCTAssertEqual(sut.formatDecimalString(decimalString), 25.5)
    }
    
    func givenDecimalStringWithPeriod_whenConvertingToDouble_thenReturnDouble() {
        let decimalString = "2.5"
        XCTAssertEqual(sut.formatDecimalString(decimalString), 2.5)
    }
    
    func test_givenTimestamp_whenNotNil_thenReturnTimestamp() {
        let timestamp = 12345678.0
        XCTAssertEqual(sut.setTimestamp(for: timestamp), 12345678.0)
    }
    
    func test_givenString_whenConvertToInt_thenReturnInt() {
        let value = "1234"
        XCTAssertEqual(sut.convertStringToInt(value), 1234)
    }
    
    func test_givenPriceAndCurrency_whenFormattingPrice_thenReturnPrice() {
        let currencyCode = "USD"
        let price = 21.5
        let itemPrice = sut.formatCurrency(with: price, currencyCode: currencyCode)
        XCTAssertEqual(itemPrice, "$ 21.5")
    }
    
    func test_givenLanguageCode_whenConvertingToLanguageName_thenLanguageName() {
        let languageName = sut.getlanguageName(from: "fr")
        XCTAssertEqual(languageName, "French")
    }
    
    func test_givenStringWithMorethan10Numbers_whenCheckingIfIsbn_thenReturnTrue() {
        XCTAssertTrue(sut.isIsbn("01234567890"))
    }
    
    func test_givenStringWithLessthan10Numbers_whenCheckingIfIsbn_thenReturnFalse() {
        XCTAssertFalse(sut.isIsbn("012345"))
    }
    
    // MARK: - Failure tests
    func test_givenNilArray_whenJoining_thenReturnEmptyString() {
        let string = sut.joinArrayToString(nil)
        XCTAssertEqual(string, "")
    }
    
    func test_givenNilDateString_whenConvertingToYearOnly_thenReturnEmptyString() {
        let givenDateString = sut.displayYearOnly(for: nil)
        XCTAssertEqual(givenDateString, "")
    }
    
    func test_givenNotSupportedDateFormat_whenConvertingToYearOnly_thenReturnEmptyString() {
        let givenDateString = "123123D/FSDF3423234"
        let yearString = sut.displayYearOnly(for: givenDateString)
        XCTAssertEqual(yearString, "")
    }
    
    func test_givenNilDecimalString_whenConvertingToDouble_thenReturnZero() {
        XCTAssertEqual(sut.formatDecimalString(nil), 0)
    }
    
    func test_givenStringWithLetter_whenConvertingToDouble_thenReturnZero() {
        XCTAssertEqual(sut.formatDecimalString("abcde"), 0)
    }
    
    func test_givenNilTimestamp_whenSettingValue_thenReturnCurrentDateConvertedToDouble() {
        XCTAssertNotNil(sut.setTimestamp(for: nil))
    }
    
    func test_givenStringWithLetters_whenConvertingToInt_thenReturnZero() {
        let value = "AZERTY"
        XCTAssertEqual(sut.convertStringToInt(value), 0)
    }
    
    func test_givenNilString_whenConvertingToInt_thenReturnZero() {
        XCTAssertEqual(sut.convertStringToInt(nil), 0)
    }
    
    func test_givenNilPriceAndCurrency_whenFormattingPrice_thenReturnPriceSetAtZero() {
        let currencyCode = "USD"
        let itemPrice = sut.formatCurrency(with: nil, currencyCode: currencyCode)
        XCTAssertEqual(itemPrice, "$ 0")
    }
    
    func test_givenNilPriceAndNilCurrency_whenFormattingPrice_thenReturnPriceSetAtZeroWithDefaultEuroCurrency() {
        let itemPrice = sut.formatCurrency(with: nil, currencyCode: nil)
        XCTAssertEqual(itemPrice, "€ 0")
    }
    
    func test_givenPriceAndNilCurrency_whenFormattingPrice_thenReturnPriceWithDefaultEuroCurrency() {
        let itemPrice = sut.formatCurrency(with: 25, currencyCode: nil)
        XCTAssertEqual(itemPrice, "€ 25")
    }
    
    func test_givenNilLanguageCode_whenGettingLanguageName_returnEmptyString() {
        XCTAssertEqual(sut.getlanguageName(from: nil), "")
    }
    
    func test_givenNonExistantLanguageCode_whenGettingLanguageName_returnEmptyString() {
        XCTAssertEqual(sut.getlanguageName(from: "eeeeeeeee"), "")
    }
}
