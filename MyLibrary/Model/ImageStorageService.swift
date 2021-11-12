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
    func saveBookCoverToFirebase(for image: Data?, nameID: String, type: CollectionDocumentKey, completion: @escaping (FirebaseError?) -> Void)
    func deleteBookCoverFromStorage(for id: String, completion: @escaping (FirebaseError?) -> Void)
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
    
    private func storeImage(for imageData: Data?, id: String, completion: @escaping (Result<String?, FirebaseError>) -> Void) {
        guard let userID = userID, let imageData = imageData else { return }
        
        let imageStorageRef = storageReference.child(userID).child("images").child(id)
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
    
    func saveBookCoverToFirebase(for imageData: Data?,
                                 nameID: String,
                                 type: CollectionDocumentKey,
                                 completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
       
        storeImage(for: imageData, id: nameID) { [weak self] result in
            switch result {
            case .success(let imageStringURL):
                guard let imageStringURL = imageStringURL else { return }
                switch type {
                case .books:
                    let bookRef = self?.usersCollectionRef.document(userID).collection(CollectionDocumentKey.books.rawValue).document(nameID)
                    bookRef?.updateData(["volumeInfo.imageLinks.thumbnail": imageStringURL])
                case .users:
                    let userRef = self?.usersCollectionRef.document(userID)
                    userRef?.updateData(["photoURL": imageStringURL])
                }
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
    
    func deleteBookCoverFromStorage(for id: String, completion: @escaping (FirebaseError?) -> Void) {
        
    }
}
