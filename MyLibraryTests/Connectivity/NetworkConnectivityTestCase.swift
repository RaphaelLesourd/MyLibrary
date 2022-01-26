//
//  NetworkConnectivityTestCase.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 21/12/2021.
//

import XCTest
@testable import MyLibrary

class NetworkConnectivityTestCase: XCTestCase {

    var sut: Networkconnectivity!
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
        sut = Networkconnectivity.shared
        sut.startMonitoring()
    }
    
    override func tearDown() {
        super.tearDown()
        sut.status = .requiresConnection
        sut = nil
    }

    // MARK: - tests
    func  test_givenStatusSatisfied_whenMonitoring_thenIsReachableTrue() {
        sut.status = .satisfied
        XCTAssertEqual(sut?.isReachable, true)
    }
    
    func  test_givenStatusUnsatisfied_whenMonitoring_thenIsReachableFalse() {
        sut.status = .unsatisfied
        XCTAssertEqual(sut?.isReachable, false)
    }
}
