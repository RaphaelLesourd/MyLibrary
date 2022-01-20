//
//  RecommendationServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class RecommendationServiceMock: RecommendationServiceProtocol {
    let users: [UserModel] = [UserModel(id: "",
                                  userID: "",
                                  displayName: "TestUser",
                                  email: "TestEmail",
                                  photoURL: "testUrl",
                                  token: "TestToken")]
    
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {}
    
    func removeFromRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {}
    
    func retrieveRecommendingUsers(completion: @escaping (Result<[UserModel], FirebaseError>) -> Void) {
        completion(.success(users))
    }
}
