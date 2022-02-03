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
import FirebaseMessaging

class AccountService {

    typealias CompletionHandler = (FirebaseError?) -> Void
    private let user = Auth.auth().currentUser
    private let userService: UserServiceProtocol
    private let libraryService: LibraryServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let fcmToken = Messaging.messaging().fcmToken

    init(userService: UserServiceProtocol,
         libraryService: LibraryServiceProtocol,
         categoryService: CategoryServiceProtocol) {
        self.userService = userService
        self.libraryService = libraryService
        self.categoryService = categoryService
    }
    
    private func passwordMatch(with userCredentials: AccountCredentials) -> Bool {
        return userCredentials.password == userCredentials.confirmPassword
    }
  
    private func removeFirestoreListeners() {
        libraryService.removeBookListener()
        categoryService.removeListener()
        userService.updateFcmToken(with: "")
    }
}
// MARK: - AccountServiceProtocol
extension AccountService: AccountServiceProtocol {
    
    // MARK: Create
    func createAccount(for userCredentials: AccountCredentials?, completion: @escaping CompletionHandler) {
        guard Networkconnectivity.shared.isReachable == true else {
            completion(.noNetwork)
            return
        }
        guard let userCredentials = userCredentials, passwordMatch(with: userCredentials) == true else {
            completion(.passwordMismatch)
            return
        }
        Auth.auth().createUser(withEmail: userCredentials.email,
                               password: userCredentials.password) { [weak self] (authUser, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.firebaseAuthError(error))
                return
            }
            guard let user = authUser?.user else { return }
            let newUser = UserModelDTO(userID: user.uid,
                                    displayName: userCredentials.userName ?? "",
                                    email: user.email ?? "",
                                    photoURL: "",
                                    token: self.fcmToken ?? "")
            self.userService.createUserInDatabase(for: newUser) { error in
               completion(error)
            }
        }
    }
    
    // MARK: Delete
    func deleteAccount(with userCredentials: AccountCredentials?,
                       completion: @escaping CompletionHandler) {
        guard Networkconnectivity.shared.isReachable == true else {
            completion(.noNetwork)
            return
        }
        guard let userCredentials = userCredentials else { return }
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: userCredentials.email,
                                                                      password: userCredentials.password)
        // Reauthenticate
        user?.reauthenticate(with: credential) { [weak self] _, error  in
            guard let self = self else { return }
            if let error = error {
                completion(.firebaseAuthError(error))
                return
            }
            // Delete user from firestore
            self.userService.deleteUser { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                // Delete account
                self.user?.delete { error in
                    if let error = error {
                        completion(.firebaseError(error))
                        return
                    }
                    // Sign out
                    self.signOut { error in
                        if let error = error {
                            completion(.firebaseError(error))
                            return
                        }
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // MARK: Log in
    func login(with userCredentials: AccountCredentials?,
               completion: @escaping CompletionHandler) {
        guard let userCredentials = userCredentials else { return }
        Auth.auth().signIn(withEmail: userCredentials.email, password: userCredentials.password) { _, error in
            if let error = error {
                completion(.firebaseAuthError(error))
                return
            }
            completion(nil)
        }
    }
    
    // MARK: Sign out
    func signOut(completion: @escaping CompletionHandler) {
        do {
            removeFirestoreListeners()
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    
    // MARK: Forgot password
    func sendPasswordReset(for email: String, completion: @escaping CompletionHandler) {
        guard Networkconnectivity.shared.isReachable == true else {
            completion(.noNetwork)
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.firebaseAuthError(error))
                return
            }
            completion(nil)
        }
    }
}
