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
    
    init(registerIn application: UIApplication, userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        super.init()
        register(application)
    }
    
    func setBadge(to count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    // MARK: - Private functions
    private func register(_ application: UIApplication) {
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        // Register for remote notifications.
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, _ in
            if success == true {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
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
        if let bookID = userInfo[DocumentKey.postID.rawValue] as? String {
            print("received bookID: \(bookID)")
            // TODO: - Navigate to comment VC & display comment for bookID
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        didReceive(response.notification)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        didReceive(notification)
        completionHandler([.banner, .list, .badge, .sound])
    }
}
