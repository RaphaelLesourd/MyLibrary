//
//  FakeData.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 30/10/2021.
//
import Foundation
@testable import MyLibrary

class FakeData {

    static var bookCorrectData: Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: "BookFakeData", withExtension: "json")!
        return try? Data(contentsOf: url)
    }
    
    static var bookEmptyCorrectData: Data? {
        let bundle = Bundle(for: FakeData.self)
        let url = bundle.url(forResource: "BookEmptyFakeData", withExtension: "json")!
        return try? Data(contentsOf: url)
    }

    static let bookIncorrectData = "incorrectData".data(using: .utf8)!
    
    static let correctMessageToPost = MessageModel(title: "Title", body: "Body", bookID: "123456", ownerID: "11111", imageURL: "", token: "AAAABBBCCCCDDDD")
   
    class ApiError: Error {}
    static let error = ApiError()
}
