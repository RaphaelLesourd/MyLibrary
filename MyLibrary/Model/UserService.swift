//
//  UserService.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol UserServiceProtocol {
    func createUserInDatabase(for user: CurrentUser?, completion: @escaping (FirebaseError?) -> Void)
    func retrieveUser(completion: @escaping (Result<CurrentUser?, FirebaseError>) -> Void)
    func updateUserName(with username: String?, completion: @escaping (FirebaseError?) -> Void)
    func deleteUser(completion: @escaping (FirebaseError?) -> Void)
}

class UserService {
    // MARK: - Properties
    typealias CompletionHandler = (FirebaseError?) -> Void
    private let db = Firestore.firestore()
    let usersCollectionRef: CollectionReference
    var userId = Auth.auth().currentUser?.uid
    
    // MARK: - Intializer
    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
}
// MARK: - UserServiceProtocol Extension
extension UserService: UserServiceProtocol {

    // MARK: Create
    func createUserInDatabase(for currentUser: CurrentUser?, completion: @escaping CompletionHandler) {
        guard let currentUser = currentUser else { return }
        
        let userRef = usersCollectionRef.document(currentUser.userId)
        do {
            try userRef.setData(from: currentUser)
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    // MARK: Retrieve
    func retrieveUser(completion: @escaping (Result<CurrentUser?, FirebaseError>) -> Void) {
        guard let userId = userId else { return }
       
        let userRef = usersCollectionRef.document(userId)
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
            } catch { completion(.failure(.firebaseError(error))) }
        }
    }
    
    // MARK: Update
    func updateUserName(with username: String?, completion: @escaping CompletionHandler) {
        guard let userId = userId,
              let username = username,
              !username.isEmpty else {
            completion(.noUserName)
            return
        }
        usersCollectionRef.document(userId).updateData([UserDocumentKey.username.rawValue : username]) { error in
            if let error = error {
                completion(.firebaseError(error))
            }
            completion(nil)
        }
    }
    
    // MARK: Delete
    func deleteUser(completion: @escaping CompletionHandler) {
        guard let userId = userId else { return }
       
        usersCollectionRef.document(userId).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
