//
//  CommentService.swift
//  MyLibrary
//
//  Created by Birkyboy on 28/11/2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol CommentServiceProtocol {
    func addComment(for bookID: String, ownerID: String, commentID: String?, comment: String,
                    completion: @escaping (FirebaseError?) -> Void)
    func getComments(for bookID: String, ownerID: String, completion: @escaping (Result<[CommentModel], FirebaseError>) -> Void)
    func deleteComment(for bookID: String, ownerID: String, comment: CommentModel, completion: @escaping (FirebaseError?) -> Void)
    func getUserDetail(for userID: String, completion: @escaping (Result<CurrentUser?, FirebaseError>) -> Void)
    var commentListener: ListenerRegistration? { get set }
}

class CommentService: CommentServiceProtocol {
    
    // MARK: - Properties
    private let db = Firestore.firestore()
  
    let userRef         : CollectionReference
    var userID          : String
    var commentListener : ListenerRegistration?
    
    // MARK: - Initializer
    init() {
        self.userRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID  = Auth.auth().currentUser?.uid ?? ""
    }
 }
extension CommentService {
 
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
  
    func getComments(for bookID: String, ownerID: String, completion: @escaping (Result<[CommentModel], FirebaseError>) -> Void) {
        let docRef = userRef
            .document(ownerID)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(bookID)
            .collection(CollectionDocumentKey.comments.rawValue)
            .order(by: DocumentKey.timestamp.rawValue, descending: true)
        
        docRef.addSnapshotListener { querySnapshot, error in
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
                return data.isEmpty ? completion(.success([])) : completion(.success(data))
            }
        }
    }
    
    func deleteComment(for bookID: String, ownerID: String, comment: CommentModel, completion: @escaping (FirebaseError?) -> Void) {
        guard let commentID = comment.uid else { return }
        guard let commentUserID = comment.userID, commentUserID == userID else {
            print("current user did not post this comment")
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
    
    func getUserDetail(for userID: String, completion: @escaping (Result<CurrentUser?, FirebaseError>) -> Void) {
        let docRef = userRef.document(userID)
        docRef.getDocument { querySnapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            do {
                let document = try querySnapshot?.data(as: CurrentUser.self)
                completion(.success(document))
            } catch {
                completion(.failure(.firebaseError(error)))
            }
        }
    }
}
