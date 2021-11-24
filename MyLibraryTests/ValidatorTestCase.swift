//
//  ValidatorTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 22/11/2021.
//

import XCTest
@testable import MyLibrary

class ValidatorTestCase: XCTestCase {

    var sut: ValidatorProtocol!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = Validator()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Success tests
    func test_givenEmailAdress_whenCheckingValidity_thenReturnTrue() {
        XCTAssertTrue(sut.validateEmail("testemail@test.com"))
        XCTAssertTrue(sut.validateEmail("test.email@test.co.uk"))
        XCTAssertTrue(sut.validateEmail("test-email@test.fr"))
    }
    
    /// * At least 1 uppercase letter, 1 digits, one special character , 6 characters long
    func test_givenPassword_whenCheckingValidity_thenReturnTrue() {
        XCTAssertTrue(sut.validatePassword("Test21@"))
        XCTAssertTrue(sut.validatePassword("Testing2#"))
        XCTAssertTrue(sut.validatePassword("Testing22111!"))
        XCTAssertTrue(sut.validatePassword("tesTing2&"))
    }
    
    func test_givenStringWithMorethan10Numbers_whenCheckingIfIsbn_thenReturnTrue() {
        XCTAssertTrue(sut.validateIsbn("01234567890"))
    }

    // MARK: - Fail tests
    func test_givenEmailAdress_whenChekcValidity_thenReturnFalse() {
        XCTAssertFalse(sut.validateEmail("testemail@@test.com"))
        XCTAssertFalse(sut.validateEmail("ttest.com"))
        XCTAssertFalse(sut.validateEmail("t@test"))
        XCTAssertFalse(sut.validateEmail("@test.com"))
        XCTAssertFalse(sut.validateEmail("testemail@"))
        XCTAssertFalse(sut.validateEmail("testemail@@test."))
        XCTAssertFalse(sut.validateEmail("testemail@test/com"))
        XCTAssertFalse(sut.validateEmail("testemail@test@com"))
        XCTAssertFalse(sut.validateEmail(""))
        XCTAssertFalse(sut.validateEmail(nil))
    }
    
    /// * At least 1 uppercase letter, 1 digits, one special character , 6 characters long
    func test_givenPassword_whenCheckingValidity_thenReturnFalse() {
        XCTAssertFalse(sut.validatePassword("T21@"))
        XCTAssertFalse(sut.validatePassword("test21@"))
        XCTAssertFalse(sut.validatePassword("21@"))
        XCTAssertFalse(sut.validatePassword("T21"))
        XCTAssertFalse(sut.validatePassword("azertyuip21@"))
        XCTAssertFalse(sut.validatePassword("azertyuiop"))
        XCTAssertFalse(sut.validatePassword("AZERTYU21@"))
        XCTAssertFalse(sut.validatePassword(""))
        XCTAssertFalse(sut.validatePassword(nil))
    }
    
    func test_givenStringWithLessthan10Numbers_whenCheckingIfIsbn_thenReturnFalse() {
        XCTAssertFalse(sut.validateIsbn("012345"))
    }
    
}
