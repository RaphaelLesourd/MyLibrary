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
    func login(with currentUser: NewUser?, completion: @escaping (UserError?) -> Void)
    func logout(completion: @escaping (UserError?) -> Void)
    func sendPasswordReset(for email: String, completion: @escaping (UserError?) -> Void)
    func saveUserDisplayName(_ name: String, completion: @escaping (UserError?) -> Void)
    func deleteAccount(with currentUser: NewUser?, completion: @escaping (UserError?) -> Void)
}

class UserManager: UserManagerProtocol {

    typealias CompletionHandler = (UserError?) -> Void
    private let user = Auth.auth().currentUser
    
    // create account
    func createAccount(for newUser: NewUser?, completion: @escaping CompletionHandler) {
        guard let newUser = newUser else { return }
        guard passwordMatch(with: newUser) == true else {
            completion(.passwordMismatch)
            return
        }
        Auth.auth().createUser(withEmail: newUser.email, password: newUser.password) { [weak self] _, error in
            guard let self = self else { return }
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            self.saveUserDisplayName(newUser.userName ?? "Unknown") { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
        }
    }
    
    func saveUserDisplayName(_ name: String, completion: @escaping CompletionHandler) {
        let changeRequest = user?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // delete account
    func deleteAccount(with currentUser: NewUser?, completion: @escaping CompletionHandler) {
        guard let currentUser = currentUser else { return }
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: currentUser.email, password: currentUser.password)
        user?.reauthenticate(with: credential) { _, error  in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            
            // User re-authenticated.
            self.user?.delete { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                // TODO: Delete data from firestore / firestorage.
                self.logout { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                    completion(nil)
                }
            }
        }
    }

    // Log in
    func login(with currentUser: NewUser?, completion: @escaping CompletionHandler) {
        guard let currentUser = currentUser else { return }
        Auth.auth().signIn(withEmail: currentUser.email, password: currentUser.password) { _, error in
            if let error = error {
                completion(.firebaseError(error))
            } else {
                completion(nil)
            }
        }
    }
    
    // log out
    func logout(completion: @escaping CompletionHandler) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    
    // forgot password
    func sendPasswordReset(for email: String, completion: @escaping CompletionHandler) {
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
