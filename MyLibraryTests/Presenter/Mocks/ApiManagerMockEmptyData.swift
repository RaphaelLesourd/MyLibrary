//
//  ApiManagerMockEmptyData.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 24/01/2022.
//


import Foundation
@testable import MyLibrary

class ApiManagerMockEmptyData: SearchBookService {
    func getBooks(for query: String, fromIndex: Int, completion: @escaping (Result<[ItemDTO], ApiError>) -> Void) {
        completion(.success([]))
    }
    
    func sendPushNotification(with message: MessageModel, completion: @escaping (ApiError?) -> Void) {
        completion(nil)
    }
}
