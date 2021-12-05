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
    
    private weak var delegate: NotificationManagerDelegate?
    
    init(registerIn application: UIApplication,
         delegate: NotificationManagerDelegate,
         userService: UserServiceProtocol = UserService()) {
        self.delegate = delegate
        self.userService = userService
        super.init()
        register(application)
    }
    
    public func setBadge(to count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    // MARK: - Private functions
    private func register(_ application: UIApplication) {
        
        // Setting the Firebase Messaging delegate to self
        // so that we are getting all the information to this wrapper class
        Messaging.messaging().delegate = self
        // Same for Apple's Notification Center
        UNUserNotificationCenter.current().delegate = self
        
        // The notification elements we care about
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        // Register for remote notifications.
        // This shows a permission dialog on first run,
        // to show the dialog at a more appropriate time
        // move this registration accordingly.
        UNUserNotificationCenter.current().requestAuthorization(options: options) {_, _ in }
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
        
        updateFirestorePushTokenIfNeeded()
    }
    
    private func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            userService.updateFcmToken(with: token)
        }
    }
    
    private func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        delegate?.notificationsManager(didReceiveNotification: userInfo)
    }
}
// MARK: - Messaging delegate
extension NotificationManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
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
