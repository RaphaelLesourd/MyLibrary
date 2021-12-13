//
//  NotificationManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/12/2021.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

protocol NotificationManagerProtocol {
    func registerNotifications()
    func setBadge(to count: Int)
}

class NotificationManager: NSObject {
    // MARK: - Properties
    private var userService: UserServiceProtocol
    private var libraryService: LibraryServiceProtocol
    
    // MARK: - Initializer
    init(userService: UserServiceProtocol, libraryService: LibraryServiceProtocol) {
        self.userService = userService
        self.libraryService = libraryService
        super.init()
    }

    // MARK: - Private functions
    private func updateToken() {
        if let token = Messaging.messaging().fcmToken {
            userService.updateFcmToken(with: token)
        }
    }

    private func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let bookID = userInfo[DocumentKey.bookID.rawValue] as? String,
              let ownerID = userInfo[DocumentKey.ownerID.rawValue] as? String else { return }
        
        libraryService.getBook(for: bookID, ownerID: ownerID) { [weak self] result in
            switch result {
            case .success(let book):
                self?.presentCommentController(with: book)
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    
    private func presentCommentController(with book: Item) {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let rootViewController = scene?.window?.rootViewController as? TabBarController
        let navController = rootViewController?.selectedViewController as? UINavigationController
        let commentController = CommentsViewController(book: book,
                                                       commentService: CommentService(),
                                                       messageService: MessageService(),
                                                       validator: Validator())
        if let currentController = navController?.viewControllers.last,
           !currentController.isKind(of: CommentsViewController.self) {
            navController?.show(commentController, sender: nil)
        }
    }
}
// MARK: - Messaging delegate
extension NotificationManager: MessagingDelegate {
   
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateToken()
    }
}
// MARK: - NotificationCenter Delegate
extension NotificationManager: UNUserNotificationCenterDelegate {
   
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        didReceive(response.notification)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .badge, .sound])
    }
}
// MARK: - Extension NotificationProtocol
extension NotificationManager: NotificationManagerProtocol {
  
    func setBadge(to count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    
    func registerNotifications() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, _ in
            if success == true {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        updateToken()
    }
}
