//
//  ImageStorageService.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/11/2021.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

protocol ImageStorageProtocol {
    func storeBookCoverImage(for imageData: Data?, nameID: String, completion: @escaping (Result<String, FirebaseError>) -> Void)
    func updateUserImage(for imageData: Data?, completion: @escaping (FirebaseError?) -> Void)
    func deleteImageFromStorage(for id: String, completion: @escaping (FirebaseError?) -> Void)
}

class ImageStorageService {
    var userID = Auth.auth().currentUser?.uid
    private let db                  = Firestore.firestore()
    private let usersCollectionRef  : CollectionReference
    private var storageReference    : StorageReference
    
    init() {
        storageReference   = Storage.storage().reference()
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
    
    private func addImageToStorage(for imageData: Data?, id: String,
                                   completion: @escaping (Result<String?, FirebaseError>) -> Void) {
        guard let userID = userID, let imageData = imageData else { return }
        
        let imageStorageRef = storageReference
            .child(userID).child("images")
            .child(id)
        
        imageStorageRef.putData(imageData, metadata: nil, completion: { ( _, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            imageStorageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(.failure(.firebaseError(error)))
                    return
                }
                completion(.success(url?.absoluteString))
            })
        })
    }
}

// MARK: - ImageStorageProtocol Extension
extension ImageStorageService: ImageStorageProtocol {
    
    func storeBookCoverImage(for imageData: Data?, nameID: String,
                             completion: @escaping (Result<String, FirebaseError>) -> Void) {
        addImageToStorage(for: imageData, id: nameID) { result in
            switch result {
            case .success(let imageStringURL):
                guard let imageStringURL = imageStringURL else { return }
                completion(.success(imageStringURL))
            case .failure(let error):
                completion(.failure(.firebaseError(error)))
            }
        }
    }
    
    func updateUserImage(for imageData: Data?, completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        
        addImageToStorage(for: imageData, id: "profileImage") { [weak self] result in
            switch result {
            case .success(let imageStringURL):
                guard let imageStringURL = imageStringURL else { return }
                self?.usersCollectionRef.document(userID).updateData(["photoURL": imageStringURL])
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
    
    func deleteImageFromStorage(for id: String, completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        
        let imageStorageRef = storageReference
            .child(userID)
            .child("images")
            .child(id)
        
        imageStorageRef.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}