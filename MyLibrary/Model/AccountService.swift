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

protocol AccountServiceProtocol {
    func createAccount(for userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void)
    func deleteAccount(with userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void)
    func login(with userCredentials: AccountCredentials?, completion: @escaping (FirebaseError?) -> Void)
    func signOut(completion: @escaping (FirebaseError?) -> Void)
    func sendPasswordReset(for email: String, completion: @escaping (FirebaseError?) -> Void)
}

class AccountService {
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    let user = Auth.auth().currentUser
    var userService: UserServiceProtocol
    
    // MARK: - Initializer
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    // MARK: - Private functions
    private func passwordMatch(with userCredentials: AccountCredentials) -> Bool {
        return userCredentials.password == userCredentials.confirmPassword
    }
}
// MARK: - AccountServiceProtocol Extension
extension AccountService: AccountServiceProtocol {
    
    // MARK: Create
    func createAccount(for userCredentials: AccountCredentials?, completion: @escaping CompletionHandler) {
        guard let userCredentials = userCredentials else { return }
        guard passwordMatch(with: userCredentials) == true else {
            completion(.passwordMismatch)
            return
        }
        Auth.auth().createUser(withEmail: userCredentials.email,
                               password: userCredentials.password) { [weak self] (authUser, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            guard let user = authUser?.user else { return }
            let newUser = CurrentUser(userId: user.uid,
                                      displayName: userCredentials.userName ?? "",
                                      email: user.email ?? "",
                                      photoURL: "")
            self.userService.createUserInDatabase(for: newUser) { error in
                if let error = error {
                    completion(.firebaseError(error))
                }
                completion(nil)
            }
        }
    }

    // MARK: Delete
    func deleteAccount(with userCredentials: AccountCredentials?, completion: @escaping CompletionHandler) {
        guard let userCredentials = userCredentials else { return }
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: userCredentials.email,
                                                                      password: userCredentials.password)
        // Reauthenticate
        user?.reauthenticate(with: credential) { [weak self] _, error  in
            guard let self = self else { return }
            if let error = error {
                completion(.firebaseError(error))
            }
            // Delete user from firestore
            self.userService.deleteUser { error in
                if let error = error {
                    completion(.firebaseError(error))
                }
                // Delete account
                self.user?.delete { error in
                    if let error = error {
                        completion(.firebaseError(error))
                    }
                    // Sign out
                    self.signOut { error in
                        if let error = error {
                            completion(.firebaseError(error))
                        }
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // MARK: Log in
    func login(with userCredentials: AccountCredentials?, completion: @escaping CompletionHandler) {
        guard let userCredentials = userCredentials else { return }
        Auth.auth().signIn(withEmail: userCredentials.email, password: userCredentials.password) { _, error in
            if let error = error {
                completion(.firebaseError(error))
            }
            completion(nil)
        }
    }
    
    // MARK: Sign out
    func signOut(completion: @escaping CompletionHandler) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    
    // MARK: Forgot password
    func sendPasswordReset(for email: String, completion: @escaping CompletionHandler) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.firebaseError(error))
            }
            completion(nil)
        }
    }
}
