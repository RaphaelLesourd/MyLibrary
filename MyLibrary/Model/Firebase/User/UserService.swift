//
//  UserService.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/11/2021.
//

import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class UserService {
    
    typealias CompletionHandler = (FirebaseError?) -> Void
    private let db = Firestore.firestore()
    
    let usersCollectionRef: CollectionReference
    var userID: String

    init() {
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
        userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    private func updateAuthDisplayName(with name: String, completion: @escaping (Error?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { (error) in
            completion(error)
        }
    }
}
// MARK: - UserService Protocol
extension UserService: UserServiceProtocol {

    // MARK: Create
    func createUserInDatabase(for currentUser: UserModelDTO?, completion: @escaping CompletionHandler) {
        guard let currentUser = currentUser else { return }
        
        let userRef = usersCollectionRef.document(currentUser.userID)
        do {
            try userRef.setData(from: currentUser)
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    // MARK: Retrieve
    func retrieveUser(for userID: String?, completion: @escaping (Result<UserModelDTO?, FirebaseError>) -> Void) {
        let currentUserID = self.userID
        let userRef = usersCollectionRef.document(userID ?? currentUserID)
        userRef.getDocument { querySnapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            do {
                guard let document = try querySnapshot?.data(as: UserModelDTO.self)  else {
                    completion(.failure(.nothingFound))
                    return
                }
                completion(.success(document))
            } catch { completion(.failure(.firebaseError(error))) }
        }
    }

    // MARK: Update
    func updateUserName(with username: String?, completion: @escaping CompletionHandler) {
        guard let username = username, !username.isEmpty else {
            completion(.noUserName)
            return
        }
        usersCollectionRef.document(userID).updateData([DocumentKey.displayName.rawValue : username]) { [weak self] error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            self?.updateAuthDisplayName(with: username) { error in
                if let error = error {
                    completion(.firebaseError(error))
                    return
                }
                completion(nil)
            }
        }
    }

    func updateFcmToken(with token: String) {
        guard !userID.isEmpty else { return }
        let userRef = usersCollectionRef.document(userID)
        userRef.setData([DocumentKey.fcmToken.rawValue: token], merge: true)
    }
    
    // MARK: Delete
    func deleteUser(completion: @escaping CompletionHandler) {
        usersCollectionRef.document(userID).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
