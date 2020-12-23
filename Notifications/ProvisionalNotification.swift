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

    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)

    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // add our notification request
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            fatalError(error.localizedDescription)
        }
    }
    print("notified??")
}
