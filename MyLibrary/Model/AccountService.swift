//
//  User.swift
//  MyLibrary
//
//  Created by Birkyboy on 25/10/2021.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseMessaging

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
    let userService: UserServiceProtocol
    
    private let fcmToken = Messaging.messaging().fcmToken
    
    // MARK: - Initializer
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    // MARK: - Private functions
    private func passwordMatch(with userCredentials: AccountCredentials) -> Bool {
        return userCredentials.password == userCredentials.confirmPassword
    }
    
    private func saveUser(for newUser: UserModel, completion: @escaping (FirebaseError?) -> Void) {
        userService.createUserInDatabase(for: newUser) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
// MARK: - Extension AccountServiceProtocol
extension AccountService: AccountServiceProtocol {
    
    // MARK: Create
    func createAccount(for userCredentials: AccountCredentials?, completion: @escaping CompletionHandler) {
        guard Networkconnectivity.isConnectedToNetwork() == true else {
            completion(.noNetwork)
            return
        }
        guard let userCredentials = userCredentials,
              passwordMatch(with: userCredentials) == true else {
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
            let newUser = UserModel(userId: user.uid,
                                      displayName: userCredentials.userName ?? "",
                                      email: user.email ?? "",
                                      photoURL: "",
                                      token: self.fcmToken ?? "")
            self.saveUser(for: newUser) { error in
                if let error = error {
                    completion(.firebaseAuthError(error))
                    return
                }
                completion(nil)
            }
        }
    }
    // MARK: Delete
    func deleteAccount(with userCredentials: AccountCredentials?, completion: @escaping CompletionHandler) {
        guard Networkconnectivity.isConnectedToNetwork() == true else {
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
    func login(with userCredentials: AccountCredentials?, completion: @escaping CompletionHandler) {
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
            userService.updateFcmToken(with: "")
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    // MARK: Forgot password
    func sendPasswordReset(for email: String, completion: @escaping CompletionHandler) {
        guard Networkconnectivity.isConnectedToNetwork() == true else {
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
