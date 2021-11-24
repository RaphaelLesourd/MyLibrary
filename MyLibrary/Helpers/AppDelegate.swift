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
            settings.host                  = "localhost:8080"
            settings.isPersistenceEnabled  = false
            settings.isSSLEnabled          = false
            Firestore.firestore().settings = settings

            let settingsAuth               = Auth.auth().settings
            settings.host                  = "localhost:9099"
            settings.isPersistenceEnabled  = false
            settings.isSSLEnabled          = false
            Auth.auth().settings           = settingsAuth
            
            Storage.storage().useEmulator(withHost:"localhost", port:9199)
        }
    }
    
    private func configureKeyboard() {
        IQKeyboardManager.shared.enable                        = true
        IQKeyboardManager.shared.toolbarTintColor              = .label
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText  = "Fermer"
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 60
        IQKeyboardManager.shared.shouldResignOnTouchOutside    = true
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyLibrary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
