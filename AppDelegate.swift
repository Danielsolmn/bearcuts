//
//  AppDelegate.swift
//  willbarber
//
//  Created by Daniel Woldetsadik on 8/16/25.
//

import UIKit
import Firebase
import UserNotifications

// Add notification delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
               // Handle notification tap when app is in background/closed
           func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
               let userInfo = response.notification.request.content.userInfo
               
               // Post notification to open reminder details
               NotificationCenter.default.post(
                   name: NSNotification.Name("OpenReminderDetails"),
                   object: nil,
                   userInfo: userInfo
               )
               
               // Also post a notification to mark the reminder as seen
               // Add delay to prevent rate limiting
               if let reminderId = userInfo["reminderId"] as? String {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                       NotificationCenter.default.post(
                           name: NSNotification.Name("MarkReminderAsSeen"),
                           object: nil,
                           userInfo: ["reminderId": reminderId]
                       )
                   }
               }
               
               completionHandler()
           }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Setup notifications
        setupNotifications()
        
        // Override point for customization after application launch.
        return true
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

    // MARK: - Notifications
    private func setupNotifications() {
        // Set self as notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    // MARK: - Orientation Lock
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Force portrait orientation only
        return .portrait
    }
}

