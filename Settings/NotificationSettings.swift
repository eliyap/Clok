//
//  NotificationSettings.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import UserNotifications

#warning("In Development")

struct NotificationSection: View {
    var body: some View {
        Section(header: Text("Notifications")) {
            Button("Enable Notifications") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
                    if success {
                        print("Accepted")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Test Notification", action: spawnTestNotification)
        }
    }
}

