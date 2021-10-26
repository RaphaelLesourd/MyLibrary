//
//  User.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import Foundation
import Firebase
import FirebaseAuth

protocol UserManagerProtocol {
    var userEmail: String { get set }
    var userPassword: String { get set }
    var confirmPassword: String { get set }
    func canLogin() -> Bool
    func canCreateAccount() -> Bool
    func login(completion: @escaping (Result<Bool, Error>) -> Void)
    func logout(completion: @escaping (Result<Bool, Error>) -> Void)
    func createAccount(completion: @escaping (Result<Bool, Error>) -> Void)
}

class UserManager: UserManagerProtocol {
   
    var currentUser: UserModel?
    var userEmail = String()
    var userPassword = String()
    var confirmPassword = String()

    // create account
    func createAccount(completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                completion(.failure(error))
              return
            }
            let newUserInfo = authResult?.user
            self.currentUser?.email = newUserInfo?.email
            completion(.success(true))
        }
    }

    // delete account
    
    // Log in
    func login(completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // log out
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    // reset password
    
    // MARK: - Verifications
    func canLogin() -> Bool {
        guard userEmail.validateEmail(),
              userPassword.validatePassword() else {
            return false
        }
       return true
    }
    
    func canCreateAccount() -> Bool {
        guard userEmail.validateEmail(),
              userPassword.validatePassword(),
              confirmPassword.validatePassword(),
              (userPassword == confirmPassword) else {
                  return false
              }
        return true
    }
}
