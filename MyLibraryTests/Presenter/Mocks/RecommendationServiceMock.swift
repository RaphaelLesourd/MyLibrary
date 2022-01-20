//
//  RecommendationServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class RecommendationServiceMock: RecommendationServiceProtocol {
    
    private var successTest: Bool
    
    init(_ successTest: Bool) {
        self.successTest = successTest
    }
   
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {}
    
    func removeFromRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {}
    
    func retrieveRecommendingUsers(completion: @escaping (Result<[UserModel], FirebaseError>) -> Void) {
        successTest ? completion(.success(PresenterFakeData.users)) : completion(.failure(.firebaseError(PresenterError.fail)))
    }
}
