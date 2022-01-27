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

class NotificationManager: NSObject {
    // MARK: - Properties
    private var userService: UserServiceProtocol
    private var libraryService: LibraryServiceProtocol
    private let factory: Factory
    // MARK: - Initializer
    init(userService: UserServiceProtocol,
         libraryService: LibraryServiceProtocol) {
        self.userService = userService
        self.libraryService = libraryService
        self.factory = ViewControllerFactory()
        super.init()
    }
    
    // MARK: - Private functions
    /// Update the database userInfo messaging token
    private func updateToken() {
        if let token = Messaging.messaging().fcmToken {
            userService.updateFcmToken(with: token)
        }
    }
    
    /// Handles a received push notification.
    /// - Note: Retrieve the bookID and bookOwnerID from the notification Data
    /// and fetch the book then present the commentViewController.
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let bookID = userInfo[DocumentKey.bookID.rawValue] as? String,
              let ownerID = userInfo[DocumentKey.ownerID.rawValue] as? String else { return }
        
        libraryService.getBook(for: bookID, ownerID: ownerID) { [weak self] result in
            switch result {
            case .success(let book):
                DispatchQueue.main.async {
                    self?.presentCommentController(with: book)
                }
            case .failure(let error):
                AlertManager.presentAlertBanner(as: .error, subtitle: error.description)
            }
        }
    }
    /// Presents the comment ViewController with given book fetch after receiving a push notfication.
    /// - Parameters:
    /// - book: Book the comment belongs to.
    /// - Note: Handles 2 cases when presenting the Comment viewcontroller for the iPad, presents it modally dismissi
    /// and for the iphone shows it thru the navigationController
    private func presentCommentController(with book: ItemDTO) {
        let commentController = factory.makeCommentVC(with: book)
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let rootViewController = scene?.window?.rootViewController as? IpadSplitViewController
        
        guard UIDevice.current.userInterfaceIdiom == .pad else {
            let tabBar = rootViewController?.viewController(for: .compact) as? TabBarController
            let navigationController = tabBar?.selectedViewController as? UINavigationController
            if let currentController = navigationController?.viewControllers.last,
               !currentController.isKind(of: CommentsViewController.self) {
                navigationController?.show(commentController, sender: nil)
            }
            return
        }
        rootViewController?.dismiss(animated: true)
        let commentControllerWithNavigation = UINavigationController(rootViewController: commentController)
        rootViewController?.present(commentControllerWithNavigation, animated: true)
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
extension NotificationManager: PushNotifications {
    
    func resetNotificationBadgeCount() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UserDefaults.standard.set(0, forKey: StorageKey.badge.rawValue)
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
