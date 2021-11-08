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
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    let db = Firestore.firestore()
    let usersCollectionRef: CollectionReference
    let user = Auth.auth().currentUser
    
    // MARK: - Intializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
}
// MARK: - UserServiceProtocol Extension
extension UserService: UserServiceProtocol {

    // MARK: Create
    func createUserInDatabase(for user: CurrentUser?, completion: @escaping CompletionHandler) {
        guard let user = user else { return }
        let userRef = usersCollectionRef.document(user.userId)
        do {
            try userRef.setData(from: user)
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }
    
    // MARK: Retrieve
    func retrieveUser(completion: @escaping (Result<CurrentUser?, FirebaseError>) -> Void) {
        guard let user = user else { return }
        let userRef = usersCollectionRef.document(user.uid)
        
        userRef.getDocument { querySnapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            guard let querySnapshot = querySnapshot else {
                completion(.failure(.nothingFound))
                return
            }
            do {
                if let document = try querySnapshot.data(as: CurrentUser.self) {
                    completion(.success(document))
                }
            } catch {
                completion(.failure(.firebaseError(error)))
            }
        }
    }
    
    // MARK: Update
    func updateUserName(with username: String?, completion: @escaping CompletionHandler) {
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
    
    // MARK: Delete
    func deleteUser(completion: @escaping CompletionHandler) {
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
