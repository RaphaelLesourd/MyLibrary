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
    func addToRecommandation(for book: Item?, completion: @escaping (FirebaseError?) -> Void)
    func removeFromRecommandation(for book: Item?, completion: @escaping (FirebaseError?) -> Void)
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
    
    func addToRecommandation(for book: Item?, completion: @escaping (FirebaseError?) -> Void) {
        guard let book = book, let bookID = book.etag else { return }
        let ref = recommandationCollectionRef.document(bookID)
        do {
            try ref.setData(from: book)
            ref.updateData([BookDocumentKey.recommanding.rawValue: true])
            completion(nil)
        } catch { completion(.firebaseError(error)) }
        
    }
    
    func removeFromRecommandation(for book: Item?, completion: @escaping (FirebaseError?) -> Void) {
        guard let book = book,
              let bookID = book.etag else { return }
        let ref = recommandationCollectionRef.document(bookID)
        ref.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
}
