//
//  ImageStorageService.swift
//  MyLibrary
//
//  Created by Birkyboy on 11/11/2021.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

protocol ImageStorageProtocol {

    func saveImageToFirebase(for imageURL: URL?, imageName: String,
                             completion: @escaping (Result<String?, FirebaseError>) -> Void)
}

class ImageStorage {
    var userID = Auth.auth().currentUser?.uid
    var storageReference: StorageReference
    
    init() {
        storageReference = Storage.storage().reference()
    }
}

// MARK: - ImageStorageProtocol Extension
extension ImageStorage: ImageStorageProtocol {
    
    func saveImageToFirebase(for imageURL: URL?,
                             imageName: String,
                             completion: @escaping (Result<String?, FirebaseError>) -> Void) {
        guard let imageURL = imageURL else {
            completion(.failure(.nothingFound))
            return
        }
        guard let userID = userID else { return }
       
        let documentReference = storageReference.child(userID).child(imageName)
        documentReference.putFile(from: imageURL, metadata: nil) { [weak self] ( _, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            self?.storageReference.downloadURL { (url, error) in
               
                if let error = error {
                    completion(.failure(.firebaseError(error)))
                    return
                }
                completion(.success(url?.absoluteString))
            }
        }
    }
}
