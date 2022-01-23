//
//  MessageService.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/12/2021.
//

import FirebaseFirestore
import FirebaseAuth

class MessageService {
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    
    let userRef: CollectionReference
    let apiManager: ApiManagerProtocol
    let userID: String
    
    // MARK: - Initializer
    init(apiManager: ApiManagerProtocol = ApiManager(session: .default)) {
        self.apiManager = apiManager
        self.userRef = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID = Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - Private functions
    private func getUserIds(from comments: [CommentModel]) -> [[String]] {
        let userIds = comments.compactMap { $0.userID }
        let uniqueIds = Array(Set(userIds))
        return uniqueIds.chunked(into: 10)
    }
    
    private func getUserMessageTokens(from comments: [CommentModel],
                                      for bookOwnerID: String,
                                      completion: @escaping (Result<[String], FirebaseError>) -> Void) {
        let userIds = getUserIds(from: comments)
        
        userIds.forEach { ids in
            let docRef = userRef.whereField(DocumentKey.userID.rawValue, in: ids)
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
                if let data = data {
                    let tokens = data.compactMap { $0.token}
                    completion(.success(tokens))
                }
            }
        }
    }
    
    private func sendMessage(to tokens: [String], with message: String, about book: Item) {
        tokens.forEach { token in
            postNotifications(with: token, and: message, about: book)
        }
    }
    
    private func postNotifications(with token: String,
                                   and message: String,
                                   about book: Item) {
        guard let bookTitle = book.volumeInfo?.title,
              let bookID = book.bookID,
              let ownerID = book.ownerID,
              let imageURL = book.volumeInfo?.imageLinks?.thumbnail else { return }
        let message = MessageModel(title: bookTitle.capitalized,
                                   body: "💬 \(Auth.auth().currentUser?.displayName?.capitalized ?? ""): \(message)",
                                   bookID: bookID,
                                   ownerID: ownerID,
                                   imageURL: imageURL,
                                   token: token)
        apiManager.postPushNotification(with: message) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
// MARK: - MessageService Protocol
extension MessageService: MessageServiceProtocol {
    
    func sendCommentPushNotification(for book: Item,
                                     message: String,
                                     for comments: [CommentModel],
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