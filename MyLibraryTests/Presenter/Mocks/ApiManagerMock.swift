//
//  ApiManagerMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class ApiManagerMock: SearchBookService {
    func getBooks(for query: String?, fromIndex: Int, completion: @escaping (Result<[ItemDTO], ApiError>) -> Void) {
        completion(.success(PresenterFakeData.books))
    }
    
    func sendPushNotification(with message: MessageModel, completion: @escaping (ApiError?) -> Void) {
        completion(nil)
    }
}
