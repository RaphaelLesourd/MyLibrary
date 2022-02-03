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
    
    let recommandationCollectionRef: CollectionReference
    let userRef: CollectionReference
    let userID: String

    private let db = Firestore.firestore()

    init() {
        self.recommandationCollectionRef = db.collection(CollectionDocumentKey.recommanded.rawValue)
        self.userRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - Private functions
    /// Get all userIDs for the recommanded books
    private func getUserIDs(completion: @escaping (Result<[Any], FirebaseError>) -> Void) {
        let ref = recommandationCollectionRef
        
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            let data = querySnapshot?.documents.compactMap { documents -> ItemDTO? in
                do {
                    return try documents.data(as: ItemDTO.self)
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

    /// Get all users from a list of userIDs.
    private func getUsers(from userIDs: [Any],  completion: @escaping (Result<[UserModelDTO], FirebaseError>) -> Void) {
        var users: [UserModelDTO] = []
        let ids = userIDs.chunked(into: 10)

        ids.forEach { user in
            let docRef = self.userRef.whereField(DocumentKey.userID.rawValue, in: user)
            
            docRef.getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(.firebaseError(error)))
                    return
                }
               
                let data = querySnapshot?.documents.compactMap { documents -> UserModelDTO? in
                    do {
                        return try documents.data(as: UserModelDTO.self)
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
// MARK: - RecommandationService Protocol
extension RecommandationService: RecommendationServiceProtocol {
    
    func addToRecommandation(for book: ItemDTO, completion: @escaping (FirebaseError?) -> Void) {
        guard let bookID = book.bookID else { return }
        
        let ref = recommandationCollectionRef.document(bookID)
        do {
            try ref.setData(from: book)
            ref.updateData([DocumentKey.recommanding.rawValue: true])
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
    
    func removeFromRecommandation(for book: ItemDTO, completion: @escaping (FirebaseError?) -> Void) {
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
    
    func getRecommendingUsers(completion: @escaping (Result<[UserModelDTO], FirebaseError>) -> Void) {
        getUserIDs { [weak self] result in
            switch result {
            case .success(let userIDs):
                self?.getUsers(from: userIDs) { result in
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(.firebaseError(error)))
            }
        }
    }
}
