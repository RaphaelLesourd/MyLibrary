//
//  AppDelegate.swift
//  MyLibrary
//
//  Created by Birkyboy on 23/10/2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import IQKeyboardManagerSwift
import Kingfisher
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureKeyboard()
        kingFisherCacheSetup()
        getUserDefinedData()
        Networkconnectivity.shared.startMonitoring()
        FirebaseApp.configure()
        configureFiresbaseTestEnvironement()
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
            Auth.auth().useEmulator(withHost:"localhost", port:9099)
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
    
    private func getUserDefinedData() {
        if let fcmKEY = Bundle.main.object(forInfoDictionaryKey: "fcmKey") as? String {
            ApiKeys.fcmKEY = fcmKEY
        }
        if let fcmURL = Bundle.main.object(forInfoDictionaryKey: "fcmURL") as? String {
            ApiUrl.fcmURL = fcmURL
        }
        if let googleBooksURL = Bundle.main.object(forInfoDictionaryKey: "googleBooksURL") as? String {
            ApiUrl.googleBooksURL = googleBooksURL
        }
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let currentBadgeNumber = UserDefaults.standard.integer(forKey: "badge")
        let badgeNumber = currentBadgeNumber + 1
        UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        UserDefaults.standard.set(badgeNumber, forKey: "badge")
    }

}
