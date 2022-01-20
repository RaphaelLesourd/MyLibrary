//
//  RecommandationService.swift
//  MyLibrary
//
//  Created by Birkyboy on 12/11/2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class RecommandationService {
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    let recommandationCollectionRef: CollectionReference
    let userRef: CollectionReference
    let userID: String
    
    // MARK: - Initializer
    init() {
        self.recommandationCollectionRef = db.collection(CollectionDocumentKey.recommanded.rawValue)
        self.userRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - Private functions
    private func getUserIds(completion: @escaping (Result<[Any], FirebaseError>) -> Void) {
        let ref = recommandationCollectionRef
        
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            let data = querySnapshot?.documents.compactMap { documents -> Item? in
                do {
                    return try documents.data(as: Item.self)
                } catch {
                    completion(.failure(.firebaseError(error)))
                    return nil
                }
            }
            guard let data = data else { return }
            let ids = data.map { $0.ownerID }
            let uniqueIDs = Array(Set(ids)) as [Any]
            completion(.success(uniqueIDs))
        }
    }
    
    private func getUsersFromIds(with idList: [Any],
                                 completion: @escaping (Result<[UserModel], FirebaseError>) -> Void) {
        var users: [UserModel] = []
        let ids = idList.chunked(into: 10)
        ids.forEach { user in
            let docRef = self.userRef.whereField(DocumentKey.userID.rawValue, in: user)
            
            docRef.getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(.firebaseError(error)))
                    return
                }
               
                let data = querySnapshot?.documents.compactMap { documents -> UserModel? in
                    do {
                        return try documents.data(as: UserModel.self)
                    } catch {
                        completion(.failure(.firebaseError(error)))
                        return nil
                    }
                }
                guard let data = data else { return }
                users.append(contentsOf: data)
                completion(.success(users))
            }
        }
    }
}
// MARK: - RecommandationServiceProtocol extension
extension RecommandationService: RecommendationServiceProtocol {
    
    func addToRecommandation(for book: Item,
                             completion: @escaping (FirebaseError?) -> Void) {
        guard let bookID = book.bookID else { return }
        
        let ref = recommandationCollectionRef.document(bookID)
        do {
            try ref.setData(from: book)
            ref.updateData([DocumentKey.recommanding.rawValue: true])
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    func removeFromRecommandation(for book: Item,
                                  completion: @escaping (FirebaseError?) -> Void) {
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
    
    func retrieveRecommendingUsers(completion: @escaping (Result<[UserModel], FirebaseError>) -> Void) {
        getUserIds { [weak self] result in
            switch result {
            case .success(let userIds):
                self?.getUsersFromIds(with: userIds) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(.firebaseError(error)))
            }
        }
    }
}
