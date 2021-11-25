//
//  RecommandationService.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/11/2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol RecommandationServiceProtocol {
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void)
    func removeFromRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void)
}

class RecommandationService {
    
    private let db = Firestore.firestore()
    let recommandationCollectionRef: CollectionReference
    
    // MARK: - Initializer
    init() {
        recommandationCollectionRef = db.collection(CollectionDocumentKey.recommanded.rawValue)
    }
}
// MARK: - RecommandationServiceProtocol extension
extension RecommandationService: RecommandationServiceProtocol {
    
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        let ref = recommandationCollectionRef.document(book.etag)
        do {
            try ref.setData(from: book)
            ref.updateData([DocumentKey.recommanding.rawValue: true])
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    func removeFromRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        let ref = recommandationCollectionRef.document(book.etag)
        ref.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
