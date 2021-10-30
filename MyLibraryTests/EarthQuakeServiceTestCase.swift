//
//  RecipeServiceTestCase.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 19/09/2021.
//
@testable import WorldTraveler
import XCTest
import Alamofire

class RecipeServiceTestCase: XCTestCase {
    
    private var session: Session!
    private var sut: NetworkService!
    private let url = URL(string: "myDefaultURL")!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        sut = NetworkService(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        session = nil
    }

    func test_givenMagnitudeRange_whenRequestingQuakeList_thenSuccessResponse() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { [self] request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.quakeCorrectData)
        }
        sut.getData(with: .usgs(magMin: 0, magMax: 0, startDate: "")) { (result: Result <GeoJsonModel, Error>) in
            switch result {
            case .success(let quake):
                guard let quake = quake.features else {return}
                XCTAssertNotNil(quake)
                XCTAssertEqual(quake.first?.properties?.title, "M 2.8 - Island of Hawaii, Hawaii")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func test_givenMagnitudeRange_whenRequestReturnBadData_thenDataError() {
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, FakeData.quakeIncorrectData)
        }

        sut.getData(with: .usgs(magMin: 0, magMax: 0, startDate: "")) { (result: Result <GeoJsonModel, Error>) in
            switch result {
            case .success(let quake):
                XCTAssertNil(quake)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
   
}

