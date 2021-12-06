//
//  MessageService.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/12/2021.
//

import FirebaseFirestore
import FirebaseAuth

protocol MessageServiceProtocol {
    func sendCommentNotification(for book: Item, message: String, for comments: [CommentModel], completion: @escaping (FirebaseError?) -> Void)
}

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
    private func getCommentUserID(from comments: [CommentModel]) -> [[String]] {
        return comments
            .compactMap { $0.userID }
            .chunked(into: 10)
    }
    
    private func getAllCommentSenders(for comments: [CommentModel], completion: @escaping (Result<[UserModel], FirebaseError>) -> Void) {
        let userIds = getCommentUserID(from: comments)
        
        userIds.forEach { ids in
            let docRef = userRef.whereField("userId", in: ids)
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
                    completion(.success(data))
                }
            }
        }
    }
    
    private func postPushNotifications(to users: [UserModel], with message: String, for book: Item) {
        guard let bookTitle = book.volumeInfo?.title,
              let bookID = book.bookID else { return }
        users.forEach {
            let message = MessageModel(title: bookTitle.capitalized,
                                       body: "\(Auth.auth().currentUser?.displayName?.capitalized ?? "") à dit \(message)",
                                       bookID: bookID,
                                       token: $0.token)
            apiManager.postPushNotification(with: message) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
// MARK: - MessageService Protocol
extension MessageService: MessageServiceProtocol {
    
    func sendCommentNotification(for book: Item, message: String, for comments: [CommentModel],
                                 completion: @escaping (FirebaseError?) -> Void) {
        getAllCommentSenders(for: comments) { [weak self] result in
            switch result {
            case .success(let users):
                self?.postPushNotifications(to: users, with: message, for: book)
                completion(nil)
            case .failure(let error):
                completion(.firebaseError(error))
            }
        }
    }
}
