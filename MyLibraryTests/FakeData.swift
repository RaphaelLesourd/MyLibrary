//
//  FakeData.swift
//  RecipleaseTests
//
//  Created by Birkyboy on 20/09/2021.
//

import Foundation
@testable import WorldTraveler

class FakeData {

    static var quakeCorrectData: Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: "QuakeFakeData", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static let quakeIncorrectData = "incorrectData".data(using: .utf8)!
    
    class ApiError: Error {}
    static let error = ApiError()
}
