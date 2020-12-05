//
//  RunningEntryView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import Combine
import WidgetKit

/// how long to wait before checking `RunningEntry` again
fileprivate let interval = TimeInterval(10)

struct NewRunningEntryView: View {
    
    /// manage the auto updating
    @State var running: RunningEntry? = nil
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: .zero) {
                if let running = running {
//                    WeekRect(
//                        entry: running,
//                        size: geo.size,
//                        midnight: Date().midnight
//                    )
//                        /// placeholder styling
//                        .opacity(0.5)
//                        .overlay(
//                            WeekRect(
//                                entry: running,
//                                size: geo.size,
//                                midnight: Date().midnight,
//                                border: true
//                            )
//                        )
//                        .foregroundColor(running.project.wrappedColor)
//                        .offset(y: offset(size: geo.size, running: running))
                } else {
                    EmptyView()
                }
            }
            .frame(width: geo.size.width)
        }
    }
    
    /// calculate appropriate distance to next `entry`
    func offset(size: CGSize, running: RunningEntry) -> CGFloat {
        let scale = size.height / CGFloat(.day)
        return CGFloat(max(running.start - Date().midnight, .zero)) * scale
    }
}
