//
//  MessageService.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/12/2021.
//

import FirebaseFirestore
import FirebaseAuth

class MessageService {

    private let db = Firestore.firestore()
    
    let userRef: CollectionReference
    let postNotificationService: PostNotificationService
    let userID: String
    
    init(postNotificationService: PostNotificationService) {
        self.postNotificationService = postNotificationService
        self.userRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - Private functions
    /// Makes an array of userIds  for the comment list.
    /// - parameters:
    /// - comments: Array of CommentDTO objects
    /// - returns: 2 dimensional array of strings.
    /// - Note: Due to the limitation of firestore to retreive data matching a field only by chunks of 10 maximum.
    /// The returned array of user ids is divided in smalled arrays of 10 ids each..
    private func makeUserIdList(from comments: [CommentDTO]) -> [[String]] {
        let userIds = comments.compactMap { $0.userID }
        let uniqueIds = Array(Set(userIds))
        return uniqueIds.chunked(into: 10)
    }
    
    private func getUserMessageTokens(from comments: [CommentDTO],
                                      for bookOwnerID: String,
                                      completion: @escaping (Result<[String], FirebaseError>) -> Void) {
        let userIds = makeUserIdList(from: comments)

        userIds.forEach { ids in
            let docRef = userRef.whereField(DocumentKey.userID.rawValue, in: ids)
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
                if let data = data {
                    let tokens = data.compactMap { $0.token}
                    completion(.success(tokens))
                }
            }
        }
    }

    private func sendMessage(to tokens: [String], with message: String, about book: ItemDTO) {
        tokens.forEach { token in
            let message = makeMessage(with: token, and: message, about: book)
            postNotificationService.sendPushNotification(with: message) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func makeMessage(with token: String,
                             and message: String,
                             about book: ItemDTO) -> MessageModel {
        let bookTitle = book.volumeInfo?.title ?? ""
        let bookID = book.bookID ?? ""
        let ownerID = book.ownerID ?? ""
        let imageURL = book.volumeInfo?.imageLinks?.thumbnail ?? ""
        return MessageModel(title: bookTitle.capitalized,
                            body: "💬 \(Auth.auth().currentUser?.displayName?.capitalized ?? ""): \(message)",
                            bookID: bookID,
                            ownerID: ownerID,
                            imageURL: imageURL,
                            token: token)
    }
}
// MARK: - MessageService Protocol
extension MessageService: MessageServiceProtocol {
    
    func sendCommentPushNotification(for book: ItemDTO,
                                     message: String,
                                     for comments: [CommentDTO],
                                     completion: @escaping (FirebaseError?) -> Void) {
        getUserMessageTokens(from: comments, for: book.ownerID ?? "") { [weak self] result in
            switch result {
            case .success(let tokens):
                self?.sendMessage(to: tokens, with: message, about: book)
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
}
