//
//  FootballMatchesApp.swift
//  FootballMatches
//
//  Created by Mumen Murad on 25.10.25.
//

import SwiftUI
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // This allows the banner to pop up even when the app is in the foreground
        completionHandler([.banner, .sound, .badge])
    }
}

@main
struct FootballMatchesApp: App {
    // Create the delegate
    @State private var notificationDelegate = NotificationDelegate()

    init() {
        // Set the delegate so the app knows how to handle foreground notifications
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
