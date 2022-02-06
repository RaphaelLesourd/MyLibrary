//
//  AccountServiceMock.swift
//  MyLibraryTests
//
//  Created by Birkyboy on 20/01/2022.
//

import Foundation
@testable import MyLibrary

class AccountServiceMock: AccountServiceProtocol {
    
    private var successTest: Bool
    
    init(successTest: Bool) {
        self.successTest = successTest
    }
    
    func createAccount(for userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func deleteAccount(with userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func login(with userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func signOut(completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
    
    func sendPasswordReset(for email: String, completion: @escaping (FirebaseError?) -> Void) {
        successTest ? completion(nil) : completion(.firebaseError(FakeData.PresenterError.fail))
    }
}
