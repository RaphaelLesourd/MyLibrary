//
//  CommentService.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class CommentService {
    
    // MARK: - Properties
    var userID: String
    
    private let userRef: CollectionReference
    private var commentListener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    // MARK: - Initializer
    init() {
        self.userRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
 }
// MARK: - Extension CommentServiceProtocol 
extension CommentService: CommentServiceProtocol {
  
    func addComment(for bookID: String,
                    ownerID: String,
                    commentID: String?,
                    comment: String,
                    completion: @escaping (FirebaseError?) -> Void) {
        guard !comment.isEmpty else {
            completion(.noBookTitle)
            return
        }
        
        let documentID = commentID ?? UUID().uuidString
        let docRef = userRef
            .document(ownerID)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(bookID)
            .collection(CollectionDocumentKey.comments.rawValue)
            .document(documentID)
        
        let timestamp = Date().timeIntervalSince1970
        let comment = CommentModel(uid: documentID, userID: self.userID, comment: comment, timestamp: timestamp)
       
        do {
            try docRef.setData(from: comment)
            completion(nil)
        } catch { completion(.firebaseError(error)) }
    }
  
    func getComments(for bookID: String,
                     ownerID: String,
                     completion: @escaping (Result<[CommentModel], FirebaseError>) -> Void) {
        let docRef = userRef
            .document(ownerID)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(bookID)
            .collection(CollectionDocumentKey.comments.rawValue)
            .order(by: DocumentKey.timestamp.rawValue, descending: true)
        
       commentListener = docRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            let data = querySnapshot?.documents.compactMap { documents -> CommentModel? in
                do {
                    return try documents.data(as: CommentModel.self)
                } catch {
                    completion(.failure(.firebaseError(error)))
                    return nil
                }
            }
            if let data = data {
                return completion(.success(data))
            }
        }
    }
    
    func deleteComment(for bookID: String,
                       ownerID: String,
                       comment: CommentModel,
                       completion: @escaping (FirebaseError?) -> Void) {
        guard let commentID = comment.uid else {
            completion(.nothingFound)
            return
        }
        let docRef = userRef
            .document(ownerID)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(bookID)
            .collection(CollectionDocumentKey.comments.rawValue)
            .document(commentID)
        
        docRef.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    func getUserDetail(for userID: String,
                       completion: @escaping (Result<UserModel?, FirebaseError>) -> Void) {
        let docRef = userRef.document(userID)
        
        docRef.getDocument { querySnapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            do {
                let document = try querySnapshot?.data(as: UserModel.self)
                completion(.success(document))
            } catch {
                completion(.failure(.firebaseError(error)))
            }
        }
    }
    
    func removeListener() {
        commentListener?.remove()
    }
}
