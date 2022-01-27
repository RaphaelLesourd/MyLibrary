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
   
    func addToRecommandation(for book: ItemDTO, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func removeFromRecommandation(for book: ItemDTO, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(PresenterError.fail))
    }
    
    func retrieveRecommendingUsers(completion: @escaping (Result<[UserModelDTO], FirebaseError>) -> Void) {
        successTest ? completion(.success(PresenterFakeData.users)) : completion(.failure(.firebaseError(PresenterError.fail)))
    }
}
