//
//  ApiManagerMockWithError.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class ApiManagerMockWithError: ApiManagerProtocol {
    func getData(with query: String?, fromIndex: Int, completion: @escaping (Result<[Item], ApiError>) -> Void) {
        completion(.success([]))
        completion(.failure(ApiError.noBooks))
    }
    
    func postPushNotification(with message: MessageModel, completion: @escaping (ApiError?) -> Void) {
        completion(ApiError.httpError(500))
    }
}

