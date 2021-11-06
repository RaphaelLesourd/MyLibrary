//
//  UserService.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserServiceProtocol {
    func createUserInDatabase(for user: CurrentUser?, completion: @escaping (FirebaseError?) -> Void)
    func retrieveUser(completion: @escaping (Result<CurrentUser?, FirebaseError>) -> Void)
    func updateUserName(with username: String?, completion: @escaping (FirebaseError?) -> Void)
    func deleteUser(completion: @escaping (FirebaseError?) -> Void)
}

class UserService {
    
    let db = Firestore.firestore()
    let usersCollectionRef: CollectionReference
    let user = Auth.auth().currentUser
    
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
}

extension UserService: UserServiceProtocol {

    // Create
    func createUserInDatabase(for user: CurrentUser?, completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        usersCollectionRef.document(user.id).setData(user.toDocument(id: user.id)) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // Retrieve
    func retrieveUser(completion: @escaping (Result<CurrentUser?, FirebaseError>) -> Void) {
        guard let user = user else { return }
        usersCollectionRef.document(user.uid).getDocument { (userData, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            if let data = userData?.data() {
                let currentUser = CurrentUser(firebaseUser: data)
                completion(.success(currentUser))
            }
        }
    }
    
    // Update username
    func updateUserName(with username: String?, completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        guard let username = username, !username.isEmpty else {
            completion(.noUserName)
            return
        }
        usersCollectionRef.document(user.uid).updateData([UserDocumentKey.username.rawValue : username]) { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    // TODO: Update Profile photo
    
    // Delete user
    func deleteUser(completion: @escaping (FirebaseError?) -> Void) {
        guard let user = user else { return }
        usersCollectionRef.document(user.uid).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
