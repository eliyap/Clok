//
//  WeekRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// determines what proportion of available horizontal space to consume
fileprivate let thicc = CGFloat(0.8)

struct DayRect: View {
    
    let entry: TimeEntry
    let size: CGSize
    let midnight: Date
    let height: CGFloat
    /// toggles solid fill or animated border
    var border: Bool = false
    let animationInfo: (namespace: Namespace.ID, row: Int, col: TimeInterval)
    
    @State private var opacity = 0.25
    @Environment(\.colorScheme) var mode
    
    /// adapt scale to taste
    static let cornerScale: CGFloat = CGFloat(1.0/80.0)
    
    init?(
        entry: TimeEntry,
        size: CGSize,
        midnight: Date,
        border: Bool = false,
        animationInfo: (namespace: Namespace.ID, row: Int, col: TimeInterval)
    ) {
        self.entry = entry
        self.size = size
        self.midnight = midnight
        self.border = border
        self.animationInfo = animationInfo
        
        /// Calculate the appropriate height for a time entry.
        let height = size.height * CGFloat((entry.end - entry.start) / .day)
        
        /// avoids invalid dimension warning
        guard height > 0 else { return nil }
        self.height = height
    }
    
    var body: some View {
//        Group {
//            if border {
//                BorderRect
//            } else {
//                BaseRect
//                    .foregroundColor(modeAdjusted)
//                    .overlay(EntryDetails, alignment: .top)
//                    .clipped() /// prevent details spilling over
//            }
//        }
        modeAdjusted
            .cornerRadius(min(size.width * DayRect.cornerScale, height / 2))
            .overlay(EntryDetails, alignment: .top)
            .clipped()
            .frame(width: size.width * thicc, height: height)
            .matchedGeometryEffect(
                id: NamespaceModel(
                    entry: entry,
                    row: animationInfo.row,
                    col: animationInfo.col
                ),
                in: animationInfo.namespace
            )
    }
}

// MARK:- Drawing Components
extension DayRect {
    var BaseRect: some InsettableShape {
        RoundedRectangle(cornerRadius: min(size.width * DayRect.cornerScale, height / 2))
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
            .foregroundColor(modeAdjusted)
    }

    var EntryDetails: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(entry.entryDescription)
                    .lineLimit(1)
                Spacer()
                Text(entry.projectName)
                    .lineLimit(1)
            }
            Spacer()
            if type(of: entry) == TimeEntry.self {
                Text((entry.end - entry.start).toString())
            }
        }
            .padding(3)
    }
}

// MARK:- Colors
extension DayRect {
    /// how much to brighten / darken the view.
    /// bounded (0, 1)
    /// not *technically* a stored property
    var colorAdjustment: CGFloat { 0.3 }

    /// lighten or darken to improve contrast
    var modeAdjusted: Color {
        mode == .dark
            ? entry.color.darken(by: 0.3)
            : UIColor.white.tinted(with: entry.color)
    }
}
