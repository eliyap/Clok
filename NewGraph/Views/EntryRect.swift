//
//  EntryRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// determines what proportion of available horizontal space to consume
fileprivate let thicc = CGFloat(0.8)

struct NewEntryRect: View {
    
    let entry: TimeEntryLike
    let size: CGSize
    let midnight: Date
    let height: CGFloat
    /// toggles solid fill or animated border
    var border: Bool = false

    @State private var opacity = 0.25
    @EnvironmentObject var model: NewGraphModel
    
    /// adapt scale to taste
    var cornerScale: CGFloat {
        switch model.mode {
        case .weekMode:
            return CGFloat(1.0/18.0)
        case .dayMode, .listMode:
            return CGFloat(1.0/80.0)
        }
    }
    
    
    init?(
        entry: TimeEntryLike,
        size: CGSize,
        midnight: Date,
        border: Bool = false
    ) {
        self.entry = entry
        self.size = size
        self.midnight = midnight
        self.border = border
        
        /// Calculate the appropriate height for a time entry.
        let start = max(entry.start, midnight)
        let end = min(entry.end, midnight + .day)
        let height = size.height * CGFloat((end - start) / .day)
        
        /// avoids invalid dimension warning
        guard height > 0 else { return nil }
        self.height = height
    }
    
    var body: some View {
        Group {
            if border {
                BorderRect
            } else {
                switch model.mode {
                case .weekMode:
                    BaseRect
                default:
                    DetailedRect
                }
            }
        }
            .frame(width: size.width * thicc, height: height)
    }
}

// MARK:- Drawing Components
extension NewEntryRect {
    var BaseRect: some InsettableShape {
        RoundedRectangle(cornerRadius: size.width * cornerScale)
    }
    
    /// animated border outline version
    var BorderRect: some View {
        BaseRect
            /// stroke the border, but do not animate it (caused strange drifting glitches)
            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
            .animation(.none)
            /// add a pulsing opacity animation
            .opacity(opacity)
            .onAppear { opacity = 1.0 }
            .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: true))
    }
    
    var DetailedRect: some View {
        VStack {
            Text(entry.entryDescription)
            Text(entry.projectName)
            Spacer()
            if type(of: entry) == TimeEntry.self {
                Text((entry.end - entry.start).toString())
            }
        }
            .background(BaseRect)
            .clipped()
    }
}
