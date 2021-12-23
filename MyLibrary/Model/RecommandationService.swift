//
//  RecommandationService.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/11/2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol Recommendation {
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
extension RecommandationService: Recommendation {
    
    func addToRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        guard let bookID = book.bookID else { return }
       
        let ref = recommandationCollectionRef.document(bookID)
        do {
            try ref.setData(from: book)
            ref.updateData([DocumentKey.recommanding.rawValue: true])
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    func removeFromRecommandation(for book: Item, completion: @escaping (FirebaseError?) -> Void) {
        guard let bookID = book.bookID else { return }
       
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
