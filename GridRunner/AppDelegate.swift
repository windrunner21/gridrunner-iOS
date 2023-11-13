//
//  AppDelegate.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.05.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerForNotifications()
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
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device token is: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications. Error: \(error)")
    }
    
    private func registerForNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if let error = error {
                Log.error("Error happened registering application to notification center. Error: \(error)")
            }
            
            guard granted else { return }
            Log.success("Provisional authorization granted.")
            self?.getNotifications(from: center)
        }
    }
    
    private func getNotifications(from center: UNUserNotificationCenter) {
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            let reminderNotificationRequest = Notifications.getReminderNotification()
            
            center.getPendingNotificationRequests { (requests) in
                let reminderNotificationExists = requests.contains { $0.identifier == reminderNotificationRequest.identifier}
                
                if !reminderNotificationExists {
                    center.add(reminderNotificationRequest) { (error) in
                        if error != nil {
                            Log.error("Error happened adding reminder notification request.")
                        }
                    }
                } else {
                    Log.data("Reminder notification already exists")
                    // Either remove and update or ignore the new request.
                    // Currently removing and updating.
                    center.removePendingNotificationRequests(withIdentifiers: [reminderNotificationRequest.identifier])
                    center.add(reminderNotificationRequest) { (error) in
                        if error != nil {
                            Log.error("Error happened updating reminder notification request.")
                        }
                    }
                }
            }

        }
    }
}

