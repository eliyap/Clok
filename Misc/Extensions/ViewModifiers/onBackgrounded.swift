//
//  onBackgrounded.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct OnBackgrounded: ViewModifier {
    
    var action: (Notification) -> Void
    
    init(_ action: @escaping (Notification) -> Void) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: action)
    }
}

extension View {
    func onBackgrounded(_ action: @escaping (Notification) -> Void) -> some View {
        self.modifier(OnBackgrounded(action))
    }
}
