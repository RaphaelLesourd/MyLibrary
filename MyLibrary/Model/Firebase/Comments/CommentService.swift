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
    private let userService: UserServiceProtocol
    
    // MARK: - Initializer
    init(userService: UserService) {
        self.userService = userService
        self.userRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    private func saveCommentDocument(docRef: DocumentReference,
                                     user: UserModelDTO,
                                     documentID: String,
                                     message: String,
                                     completion: @escaping (FirebaseError?) -> Void) {
        let timestamp = Date().timeIntervalSince1970
        let comment = CommentDTO(uid: documentID,
                                 userID: self.userID,
                                 userName: user.displayName,
                                 userPhotoURL: user.photoURL,
                                 message: message,
                                 timestamp: timestamp)
        do {
            try docRef.setData(from: comment)
            completion(nil)
        } catch {
            completion(.firebaseError(error))
        }
    }

    private func makeCollectionRef(for ownerID: String, and bookID: String) -> CollectionReference {
        return userRef
            .document(ownerID)
            .collection(CollectionDocumentKey.books.rawValue)
            .document(bookID)
            .collection(CollectionDocumentKey.comments.rawValue)
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
        let docRef = makeCollectionRef(for: ownerID, and: bookID).document(documentID)

        userService.retrieveUser(for: self.userID) { [weak self] result in
            switch result {
            case .success(let user):
                guard let user = user else { return }

                self?.saveCommentDocument(docRef: docRef,
                                          user: user,
                                          documentID: documentID,
                                          message: comment) { error in
                    completion(error)
                }
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
  
    func getComments(for bookID: String,
                     ownerID: String,
                     completion: @escaping (Result<[CommentDTO], FirebaseError>) -> Void) {
        let docRef = makeCollectionRef(for: ownerID, and: bookID)
            .order(by: DocumentKey.timestamp.rawValue, descending: true)
        
        commentListener = docRef.addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(.firebaseError(error)))
                return
            }
            let data = querySnapshot?.documents.compactMap { documents -> CommentDTO? in
                do {
                    return try documents.data(as: CommentDTO.self)
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
                       comment: CommentDTO,
                       completion: @escaping (FirebaseError?) -> Void) {
        guard !comment.uid.isEmpty else {
            completion(.nothingFound)
            return
        }
        let docRef = makeCollectionRef(for: ownerID, and: bookID).document(comment.uid)
        
        docRef.delete { error in
            if let error = error {
                completion(.firebaseError(error))
                return
            }
            completion(nil)
        }
    }
    
    func removeListener() {
        commentListener?.remove()
    }
}
