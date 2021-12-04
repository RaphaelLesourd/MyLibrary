//
//  MessageService.swift
//  MyLibrary
//
//  Created by Birkyboy on 04/12/2021.
//

import Foundation
import FirebaseMessaging
import FirebaseFirestore
import FirebaseAuth
import UserNotifications
import UIKit

protocol MessageServiceProtocol {
    func sendCommentNotification(for book: Item, message: String, for comments: [CommentModel], completion: @escaping (FirebaseError?) -> Void)
}

class MessageService: NSObject {
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    
    let userRef   : CollectionReference
    let apiManager: ApiManagerProtocol
    let userID    : String
    
    init(apiManager: ApiManagerProtocol = ApiManager(session: .default)) {
        self.apiManager = apiManager
        self.userRef    = db.collection(CollectionDocumentKey.users.rawValue)
        self.userID     = Auth.auth().currentUser?.uid ?? ""
    }
    
    private func getCommentUserID(from comments: [CommentModel]) -> [String] {
        let ids = comments.compactMap { $0.userID }
        return Array(Set(ids))
    }
    
    private func getAllCommentSenders(for comments: [CommentModel], completion: @escaping (Result<[UserModel], FirebaseError>) -> Void) {
      
        let userIds = getCommentUserID(from: comments)
        let docRef = userRef.whereField("userId", in: userIds)
        
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
                return data.isEmpty ? completion(.success([])) : completion(.success(data))
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
                    print(error)
                }
            }
        }
    }
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        Messaging.messaging().delegate = self
        
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    private func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            userRef.document(userID).setData(["fcmToken": token], merge: true)
        }
    }
}

extension MessageService: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }
}

extension MessageService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

// MARK: - Extension MessageServiceProtocol
extension MessageService: MessageServiceProtocol {
    
    func sendCommentNotification(for book: Item,
                                 message: String,
                                 for comments: [CommentModel],
                                 completion: @escaping (FirebaseError?) -> Void) {
        guard !comments.isEmpty else { return }
      
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
