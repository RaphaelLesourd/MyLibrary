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
    private let userID: String
    private var bookOwnerID: String?
    
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
    /// Add the book ownerID to the list of ids to send a message to.
    private func makeUserIdList(from comments: [CommentDTO]) -> [[String]] {
        var userIds = comments
            .compactMap { $0.userID }
            .filter { $0 != userID }

        if let bookOwnerID = bookOwnerID {
            userIds.append(bookOwnerID)
        }
        let uniqueIds = Array(Set(userIds))
        return uniqueIds.chunked(into: 10)
    }
    
    private func getUserMessageTokens(from comments: [CommentDTO],
                                      for bookOwnerID: String,
                                      completion: @escaping (Result<[String]?, FirebaseError>) -> Void) {
        let userIds = makeUserIdList(from: comments)

        userIds.forEach { ids in
            let docRef = userRef.whereField(DocumentKey.userID.rawValue, in: ids)

            docRef.getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(.firebaseError(error)))
                    return
                }
                let data = querySnapshot?.documents
                    .compactMap { documents -> UserModelDTO? in
                        do {
                            return try? documents.data(as: UserModelDTO.self)
                        } 
                    }
                    .compactMap { $0.token }
                completion(.success(data))
            }
        }
    }
    /// Post comment message
    /// - Parameters:
    ///  - tokens: String array or user tokens
    ///  - message: String of message to post
    ///  - book: ItemDTO object containing book information to include in the message.
    private func postMessage(to tokens: [String],
                             with message: String,
                             about book: ItemDTO) {
        tokens.forEach { token in
            let message = makeMessage(with: token, and: message, about: book)
            postNotificationService.sendPushNotification(with: message) { error in
                print(error?.localizedDescription ?? "Unable to send a message")
            }
        }
    }

    /// Make a message content
    /// - parameters:
    ///  - tokens: String array or user tokens
    ///  - message: String of message to post
    ///  - book: ItemDTO object containing book information to include in the message.
    ///  - returns: MessageModel to be sent
    private func makeMessage(with token: String,
                             and message: String,
                             about book: ItemDTO) -> MessageModel {

        return MessageModel(title: book.volumeInfo?.title?.capitalized ?? "",
                            body: "💬 \(Auth.auth().currentUser?.displayName?.capitalized ?? ""): \(message)",
                            bookID: book.bookID ?? "",
                            ownerID: book.ownerID ?? "",
                            imageURL: book.volumeInfo?.imageLinks?.thumbnail ?? "",
                            token: token)
    }
}
// MARK: Message service protocol
extension MessageService: MessageServiceProtocol {
    
    func sendCommentPushNotification(for book: ItemDTO,
                                     message: String,
                                     for comments: [CommentDTO],
                                     completion: @escaping (FirebaseError?) -> Void) {
        // Capture the book owner ID to be added to the list of userIDs
        // Allows to send comments to the book owner.
        guard let ownerID = book.ownerID else {
            completion(.unableToSendMessage)
            return
        }
        bookOwnerID = ownerID

        getUserMessageTokens(from: comments, for: ownerID) { [weak self] result in
            switch result {
            case .success(let tokens):
                guard let tokens = tokens else {
                    completion(.unableToSendMessage)
                    return
                }
                self?.postMessage(to: tokens, with: message, about: book)
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
}
