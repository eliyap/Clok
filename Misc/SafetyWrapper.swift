//
//  SafetyWrapper.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// prevents vertical scrollview from over-running the status bar
struct SafetyWrapper<Content: View>:View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack(spacing: .zero) {
            /// tiny view stops scroll from drawing above it (into the status bar)
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 1)
            content
        }
    }
}
