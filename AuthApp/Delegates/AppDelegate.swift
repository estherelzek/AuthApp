//
//  AppDelegate.swift
//  AuthApp
//
//  Created by esterelzek on 27/05/2025.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import FirebaseCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Application Lifecycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Configure Google Sign-In
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "418267979836-8uca8r0rl7kl5fvmb8tnef4qsfbqcddo.apps.googleusercontent.com"
        )
        
        return true
    }

    // MARK: - Handle URL Opens for Facebook and Google
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // Let Facebook SDK handle the URL if possible
        let handledByFacebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        
        // Let Google Sign-In SDK handle the URL if possible
        let handledByGoogle = GIDSignIn.sharedInstance.handle(url)
        
        return handledByFacebook || handledByGoogle
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AuthApp")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving Support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
