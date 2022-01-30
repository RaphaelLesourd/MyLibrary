//
//  SceneDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import Firebase
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var handle: AuthStateDidChangeListenerHandle?
    private let notificationManager: PushNotifications

    override init() {
        notificationManager = NotificationManager(userService: UserService(),
                                                  libraryService: LibraryService())
    }
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.tintColor = .appTintColor
        
        // Listens to user Auth state and route to proper ViewContoller accordingly
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if user != nil {
                self?.notificationManager.registerNotifications()
                self?.window?.rootViewController = IpadSplitViewController(style: .doubleColumn)
            } else {
                self?.window?.rootViewController = WelcomeViewController()
            }
        }
        window?.makeKeyAndVisible()
        
        // Open the CommentViewController when app is opened from Terminated state
        if let notificationResponse = connectionOptions.notificationResponse?.notification {
            notificationManager.didReceive(notificationResponse)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        notificationManager.resetNotificationBadgeCount()
    }
}

extension SceneDelegate: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
