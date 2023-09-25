//
//  Notifications.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 25.09.23.
//

import Foundation
import UserNotifications

struct Notifications {
    static func getReminderNotification() -> UNNotificationRequest {
        // Create notification content.
        let content = UNMutableNotificationContent()
        content.title = "Time for a GridRun Break"
        content.body = "Take a break and indulge in GridRun games."
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        // Specify the conditions for delivery.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (60*60*24), repeats: true)
        
        // Create notification request.
        let request = UNNotificationRequest(identifier: "reminderNotificationIdentifier", content: content, trigger: trigger)
        
        return request
    }
    
    static func scheduleMatchmakingNotification() {
        // Create notification content.
        let content = UNMutableNotificationContent()
        content.title = "Game Found"
        content.body = "Tap to return to game."
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        // Specify the conditions for delivery
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create notification request.
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                NSLog("Error happened adding matchmaking notification request.")
            }
        }
    }
}
