//
//  AppDelegate.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    var notificationCentre: NotificationCentre? = .none
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        /** Docs: https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate
         Documentation explicitly instructs developers to assign `UNUserNotificationCenterDelegate` at app start up, which is what I'm doing here.
         I have no idea if this is the right way to do it, but keeping a reference to the thing in my `AppDelegate` seems like the right way to go.
         */
        self.notificationCentre = NotificationCentre()
        return true
    }
    

}

final class NotificationCentre: NSObject, UNUserNotificationCenterDelegate {
    
    /// assign itself as the delegate, per instructions in
    /// https://developer.apple.com/documentation/usernotifications/unusernotificationcenterdelegate
    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.setNotificationCategories([
            UNNotificationCategory(
                identifier: NotificationConstants.RunningCategory,
                actions: [
                    UNNotificationAction(
                        identifier: NotificationConstants.Identifier.stop.rawValue,
                        title: "Stop"
                    )
                ],
                intentIdentifiers: [] /// no intents to declare
            )
        ])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        /// display the alert, even when the app is in the foreground
        completionHandler(.list)
    }
}
