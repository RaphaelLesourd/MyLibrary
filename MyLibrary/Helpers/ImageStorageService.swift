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
import UIKit

protocol ImageStorageProtocol {
    func saveBookCoverToFirebase(for image: UIImage?, id: String, completion: @escaping (FirebaseError?) -> Void)
}

class ImageStorage {
    var userID = Auth.auth().currentUser?.uid
    private let db                  = Firestore.firestore()
    private let usersCollectionRef  : CollectionReference
    private var storageReference    : StorageReference
    
    init() {
        storageReference   = Storage.storage().reference()
        usersCollectionRef = db.collection(CollectionDocumentKey.users.rawValue)
    }
    
    private func resizeImage(for image: UIImage) -> Data? {
        let divider: CGFloat = image.size.height > 1000 || image.size.width > 1000 ? 2 : 1
        let size = CGSize(width: image.size.width / divider, height: image.size.height / divider)
        let resizedImage = image.resizedImage(for: size)
        return resizedImage?.jpeg(.medium)
    }
    
   private func storeImage(for image: UIImage?, id: String, completion: @escaping (Result<String?, FirebaseError>) -> Void) {
        guard let userID = userID, let image = image else { return }
        
        guard let imageData = resizeImage(for: image) else { return }
        print(userID, id)
        
        storageReference = storageReference.child(userID).child("images").child(id)
        storageReference.putData(imageData, metadata: nil, completion: { [weak self] (_, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            self?.storageReference.downloadURL(completion: { (url, error) in
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
extension ImageStorage: ImageStorageProtocol {
    
    func saveBookCoverToFirebase(for image: UIImage?, id: String, completion: @escaping (FirebaseError?) -> Void) {
        guard let userID = userID else { return }
        storeImage(for: image, id: id) { [weak self] result in
            switch result {
            case .success(let imageStringURL):
                guard let imageStringURL = imageStringURL else { return }
                let bookRef = self?.usersCollectionRef.document(userID).collection(CollectionDocumentKey.books.rawValue).document(id)
                bookRef?.updateData(["volumeInfo.imageLinks.thumbnail": imageStringURL])
                
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
}
