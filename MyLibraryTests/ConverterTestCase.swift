//
//  ConvertedTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 19/11/2021.
//

import XCTest
@testable import MyLibrary

class ConverterTestCase: XCTestCase {

    var sut: ConverterProtocol?
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = Converter()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - tests
    func givenDecimalStringWithComma_whenConvertingToDouble_returnDouble() {
        let decimalString = "25,5"
        XCTAssertEqual(sut?.convertStringToDouble(decimalString), 25.5)
    }
    
    func givenDecimalStringWithPeriod_whenConvertingToDouble_thenReturnDouble() {
        let decimalString = "2.5"
        XCTAssertEqual(sut?.convertStringToDouble(decimalString), 2.5)
    }
    
    func test_givenString_whenConvertToInt_thenReturnInt() {
        let value = "1234"
        XCTAssertEqual(sut?.convertStringToInt(value), 1234)
    }
    
    func test_givenNilDecimalString_whenConvertingToDouble_thenReturnZero() {
        XCTAssertEqual(sut?.convertStringToDouble(nil), 0)
    }
    
    func test_givenStringWithLetter_whenConvertingToDouble_thenReturnZero() {
        XCTAssertEqual(sut?.convertStringToDouble("abcde"), 0)
    }
    
    func test_givenStringWithLetters_whenConvertingToInt_thenReturnZero() {
        let value = "AZERTY"
        XCTAssertEqual(sut?.convertStringToInt(value), 0)
    }
    
    func test_givenNilString_whenConvertingToInt_thenReturnZero() {
        XCTAssertEqual(sut?.convertStringToInt(nil), 0)
    }
}
