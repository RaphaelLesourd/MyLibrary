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
    var userName: String { get set }
    var userEmail: String { get set }
    var userPassword: String { get set }
    var confirmPassword: String { get set }
    
    func canLogin() -> Bool
    func canCreateAccount() -> Bool
    func login(completion: @escaping (Error?) -> Void)
    func logout(completion: @escaping (Error?) -> Void)
    func createAccount(completion: @escaping (Error?) -> Void)
    func sendPasswordReset(completion: @escaping (Error?) -> Void)
}

class UserManager: UserManagerProtocol {
    
    var currentUser = CurrentUser.shared
    var userName = String()
    var userEmail = String()
    var userPassword = String()
    var confirmPassword = String()
    
    // create account
    func createAccount(completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                completion(error)
                return
            }
            self.saveUser(with: authResult?.user) { error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
    
    private func saveUser(with user: User?, completion: @escaping (Error?) -> Void) {
        guard let user = user, let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("User").document(uid).setData(["email": user.email ?? "",
                                                     "displayName": userName,
                                                     "uid": uid
                                                    ]) { error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    // delete account
    private func deleteAccount(completion: @escaping (Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    // Log in
    func login(completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                dump(authResult?.user.email)
                completion(nil)
            }
        }
    }
    
    // log out
    func logout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    // forgot password
    func sendPasswordReset(completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
            completion(error)
        }
    }
    
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
