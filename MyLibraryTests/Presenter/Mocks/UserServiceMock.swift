//
//  UserServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import XCTest
@testable import MyLibrary

class UserServiceMock: UserServiceProtocol {

    private var successTest: Bool
    
    init(successTest: Bool) {
        self.successTest = successTest
    }
    
    func createUserInDatabase(for user: UserModelDTO?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func retrieveUser(for userID: String?, completion: @escaping (Result<UserModelDTO?, FirebaseError>) -> Void) {
        if successTest {
            completion(.success(FakeData.user))
        } else {
            completion(.success(nil))
            completion(.failure(.firebaseError(FakeData.PresenterError.fail)))
        }
    }
    
    func updateUserName(with username: String?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func deleteUser(completion: @escaping (FirebaseError?) -> Void) {}
    
    func updateFcmToken(with token: String) {}
}
