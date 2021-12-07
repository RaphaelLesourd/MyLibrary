//
//  AppDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import IQKeyboardManagerSwift
import Kingfisher
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureKeyboard()
        kingFisherCacheSetup()
        
        FirebaseApp.configure()
        configureFiresbaseTestEnvironement()
        Networkconnectivity.shared.startMonitoring()
        return true
    }
    
    private func configureFiresbaseTestEnvironement() {
        // Checking if unit tests are running
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
            print("Setting up Firebase emulator localhost:8080")
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings

            let settingsAuth = Auth.auth().settings
            settings.host = "localhost:9099"
            settings.isPersistenceEnabled = false
            settings.isSSLEnabled = false
            Auth.auth().settings = settingsAuth
            
            Storage.storage().useEmulator(withHost:"localhost", port: 9199)
        }
    }
    
    private func configureKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .label
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Fermer"
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 60
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    private func kingFisherCacheSetup() {
        let cache = ImageCache.default
        cache.memoryStorage.config.countLimit = 150
        cache.memoryStorage.config.totalCostLimit = 500 * 1024 * 1024
        cache.diskStorage.config.sizeLimit = 1000 * 1024 * 1024
        KingfisherManager.shared.downloader.downloadTimeout = 3000.0
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}
