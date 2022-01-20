//
//  ApiManagerMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class ApiManagerMock: ApiManagerProtocol {
    func getData(with query: String?, fromIndex: Int, completion: @escaping (Result<[Item], ApiError>) -> Void) {
        completion(.success([]))
    }
    
    func postPushNotification(with message: MessageModel, completion: @escaping (ApiError?) -> Void) {
        completion(nil)
    }
}
