//
//  RecommandationService.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/11/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol RecommandationServiceProtocol {
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void)
    func removeFromRecommandation(for id: String, completion: @escaping (FirebaseError?) -> Void)
}

class RecommandationService {
    
    private let db = Firestore.firestore()
    var userID     = Auth.auth().currentUser?.uid
    let recommandationCollectionRef: CollectionReference
    
    // MARK: - Initializer
    init() {
        recommandationCollectionRef = db.collection("recommanded")
    }
}
// MARK: - RecommandationServiceProtocol extension
extension RecommandationService: RecommandationServiceProtocol {
    
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        let ref = recommandationCollectionRef.document(book.etag ?? "")
        do {
            try ref.setData(from: book)
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    func removeFromRecommandation(for id: String, completion: @escaping (FirebaseError?) -> Void) {
        recommandationCollectionRef.document(id).delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
