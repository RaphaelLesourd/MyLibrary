//
//  ApiManagerMockWithError.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class ApiManagerMockWithError: SearchBookService {
    func getBooks(for query: String, fromIndex: Int, completion: @escaping (Result<[ItemDTO], ApiError>) -> Void) {
        completion(.success([]))
        completion(.failure(ApiError.noBooks))
    }
    
    func sendPushNotification(with message: MessageModel, completion: @escaping (ApiError?) -> Void) {
        completion(ApiError.httpError(500))
    }
}

