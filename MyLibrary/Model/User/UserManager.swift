//
//  User.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

protocol UserManagerProtocol {
    func createAccount(for newUser: NewUser?, completion: @escaping (UserError?) -> Void)
    func login(with user: NewUser?, completion: @escaping (UserError?) -> Void)
    func logout(completion: @escaping (UserError?) -> Void)
    func sendPasswordReset(for email: String, completion: @escaping (UserError?) -> Void)
    func saveUserDisplayName(_ name: String, completion: @escaping (UserError?) -> Void)
}

class UserManager: UserManagerProtocol {

    let db: Firestore
   
    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }
    // create account
    func createAccount(for user: NewUser?, completion: @escaping (UserError?) -> Void) {
        guard let user = user else { return }
        
        guard passwordMatch(with: user) == true else {
            completion(.passwordMismatch)
            return
        }
        Auth.auth().createUser(withEmail: user.email, password: user.password) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            self.saveUserDisplayName(user.userName ?? "") { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
        }
    }
    
    func saveUserDisplayName(_ name: String, completion: @escaping (UserError?) -> Void) {
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
        }
    }
 
    // delete account
    private func deleteAccount(completion: @escaping (UserError?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                completion(.firebaseError(error))
            } else {
                completion(nil)
            }
        }
    }
    
    // Log in
    func login(with user: NewUser?, completion: @escaping (UserError?) -> Void) {
        guard let user = user else { return }
        Auth.auth().signIn(withEmail: user.email, password: user.password) { _, error in
            if let error = error {
                completion(.firebaseError(error))
            } else {
                completion(nil)
            }
        }
    }
    
    // log out
    func logout(completion: @escaping (UserError?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    
    // forgot password
    func sendPasswordReset(for email: String, completion: @escaping (UserError?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.firebaseError(error))
            }
           completion(nil)
        }
    }
    
    // MARK: - Verifications
    private func passwordMatch(with user: NewUser) -> Bool {
        return user.password == user.confirmPassword
    }
}

enum UserError: Error {
    case passwordMismatch
    case firebaseError(Error)
    var description: String {
        switch self {
        case .passwordMismatch:
            return "Les mots de passes ne correspondent pas."
        case .firebaseError(let error):
            return error.localizedDescription
        }
    }
}
