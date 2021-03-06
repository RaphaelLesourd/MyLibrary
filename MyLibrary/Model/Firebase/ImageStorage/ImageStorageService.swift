//
//  ImageStorageService.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/11/2021.
//

import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class ImageStorageService {

    var userID: String
    
    private let db = Firestore.firestore()
    private let usersCollectionRef: CollectionReference
    private let storageReference: StorageReference

    init() {
        storageReference = Storage.storage().reference()
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }

    private func addImageToStorage(for imageData: Data?, id: String,
                                   completion: @escaping (Result<String?, FirebaseError>) -> Void) {
        guard let imageData = imageData else { return }
        
        let imageStorageRef = storageReference
            .child(userID).child(StorageKey.images.rawValue)
            .child(id)
        
        imageStorageRef.putData(imageData, metadata: nil) { ( _, error) in
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
        }
    }
}
// MARK: - ImageStorage Protocol
extension ImageStorageService: ImageStorageProtocol {

    // MARK: Add
    func saveImage(for imageData: Data?,
                   nameID: String,
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

    // MARK: Update
    func updateUserImage(for imageData: Data?,
                         completion: @escaping (FirebaseError?) -> Void) {

        addImageToStorage(for: imageData, id: StorageKey.profileImage.rawValue) { [weak self] result in
           guard let self = self else { return }

            switch result {
            case .success(let imageStringURL):
                guard let imageStringURL = imageStringURL else { return }
                self.usersCollectionRef
                    .document(self.userID)
                    .updateData([DocumentKey.photoURL.rawValue: imageStringURL])
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }

    // MARK: Delete
    func deleteImageFromStorage(for id: String,
                                completion: @escaping (FirebaseError?) -> Void) {
       let imageStorageRef = storageReference
            .child(userID)
            .child(StorageKey.images.rawValue)
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
