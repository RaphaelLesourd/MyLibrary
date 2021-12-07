//
//  NotificationManager.swift
//  MyLibrary
//
//  Created by Birkyboy on 05/12/2021.
//

import UserNotifications
import UIKit
import Firebase
import FirebaseMessaging

typealias NotificationPayload = [AnyHashable: Any]

protocol NotificationManagerDelegate: AnyObject {
    func notificationsManager(didReceiveNotification payload: NotificationPayload)
}

class NotificationManager: NSObject {
    
    var userService: UserServiceProtocol
    var libraryService: LibraryServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        self.libraryService = LibraryService()
        super.init()
    }
    
    func setBadge(to count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    // MARK: - Private functions
    func register() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Register for remote notifications.
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
    
    private func updateToken() {
        if let token = Messaging.messaging().fcmToken {
            userService.updateFcmToken(with: token)
        }
    }

    private func didReceive(_ notification: UNNotification) {
        
        let userInfo = notification.request.content.userInfo
        guard let bookID = userInfo[DocumentKey.postID.rawValue] as? String else { return }
        print(bookID)
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        if let rootViewController = scene?.window?.rootViewController,
           let tabBarController = rootViewController as? TabBarController,
           let navController = tabBarController.selectedViewController as? UINavigationController {
            libraryService.getBook(for: bookID) { result in
                if case .success(let book) = result {
                    let commentController = CommentsViewController(book: book,
                                                                   commentService: CommentService(),
                                                                   messageService: MessageService(),
                                                                   validator: Validator())
                    navController.pushViewController(commentController, animated: true)
                }
            }
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
        didReceive(notification)
        completionHandler([.banner, .list, .badge, .sound])
    }
}
