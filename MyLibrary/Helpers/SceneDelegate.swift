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
    private let notificationManager: NotificationManagerProtocol
    
    override init() {
        notificationManager = NotificationManager(userService: UserService(), libraryService: LibraryService())
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
       
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.notificationManager.registerNotifications()
                let tabController = TabBarController()
                window.rootViewController = tabController
            } else {
                let welcomeController = WelcomeViewController()
                window.rootViewController = welcomeController
            }
        }
        window.tintColor = .label
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        notificationManager.setBadge(to: 0)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
       // (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

