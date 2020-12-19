//
//  onBackgrounded.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    
    /// Do something when the app is sent to the background
    /// - Parameter action: action to perform
    /// - Returns: `Void`
    func onBackgrounded(_ action: @escaping (Notification) -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: action)
    }
}
