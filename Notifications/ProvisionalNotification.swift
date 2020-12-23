//
//  ProvisionalNotification.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import UserNotifications

func getProvisional() -> Void {
    /// semaphore to force closures to wait
    let s = DispatchSemaphore(value: 1)
    
    let center = UNUserNotificationCenter.current()
    
    /// only trigger if the user has not made a choice yet (typically on first launch)
    center.getNotificationSettings { settings in
        guard settings.authorizationStatus == .notDetermined else { return }
    }
    
    center.requestAuthorization(options: [.provisional]) { success, error in
        assert(success, "Provisional Request Failed!")
        assert(error == nil, "Encountered Error while requesting Provisional Permission: \(error!.localizedDescription)")
        s.signal()
    }
    /// wait for request to go through
    s.wait()
    sleep(1)
    #if DEBUG
    /// in development, always check the status
    center.getNotificationSettings { settings in
        assert(settings.authorizationStatus == .provisional || settings.authorizationStatus == .authorized)
        s.signal()
    }
    s.wait()
    #endif
}

func spawnTestNotification() -> Void {
    let content = UNMutableNotificationContent()
    content.title = "Feed the cat"
    content.subtitle = "It looks hungry"
    content.body = "MY BODY IS READY"

    /// choose a random identifier
    let uuid = UUID().uuidString
    
    // add our notification request
    UNUserNotificationCenter.current().add(UNNotificationRequest(
        identifier: uuid,
        content: content,
        /// notify almost instantly, as `timeInterval` cannot be 0
        trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0.005, repeats: false)
    )) { error in
        if let error = error {
            fatalError(error.localizedDescription)
        }
        /// remember this notification's ID, so that we can recall it later
        WorkspaceManager.RunningUUID = uuid
    }
}


/// Withdraw the stored notification, if any
func withdrawNotification() -> Void {
    if let uuid = WorkspaceManager.RunningUUID {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [uuid])
    }
}
