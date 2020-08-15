//
//  ZeroDate.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.17.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class ZeroDate: ObservableObject {
    /** NOTE:
     due to a bug, the `ObservableObjectPublisher` **must** be named `objectWillChange`
     https://www.hackingwithswift.com/quick-start/swiftui/how-to-send-state-updates-manually-using-objectwillchange
     */
    let objectWillChange = ObservableObjectPublisher()
    
    init(){
        /// initialize to chosen start day
        /// usually, this will do nothing, but if user changed `firstDayOfWeek`, it should bring start up to speed
        self.start = WorkspaceManager.zeroStart.startOfWeek(day: WorkspaceManager.firstDayOfWeek)
        self.zoomIdx = WorkspaceManager.zoomIdx
    }
    
    /// default to 6 days before start of today
    /// ensures the default week includes today
    var start: Date {
        willSet {
            /// update `UserDefaults`
            WorkspaceManager.zeroStart = newValue
            objectWillChange.send()
        }
    }
    
    /// computed end date
    var end: Date {
        start + .week
    }
    
    // MARK:- Date Change
    /// whether the date was moved forwards of backwards
    enum DateChange {
        case fwrd
        case back
    }
    
    var dateChange: DateChange? = nil {
        willSet {
            objectWillChange.send()
        }
    }
    
    /**
     determine what kind of apperance / disappearance animation to use
     based on whether the anchor date was just moved forwards for backwards
     */
    var slideOver: AnyTransition {
        switch dateChange {
        case .fwrd:
            return .asymmetric(
                insertion: AnyTransition
                    .move(edge: .trailing)
                    .combined(with: .opacity),
                removal: AnyTransition
                    .move(edge: .leading)
                    .combined(with: .opacity)
            )
        case .back:
            return .asymmetric(
                insertion: AnyTransition
                    .move(edge: .leading)
                    .combined(with: .opacity),
                removal: AnyTransition
                    .move(edge: .trailing)
                    .combined(with: .opacity)
            )
        default: // fallback option, fade in and out
            return .opacity
        }
    }
    
    // MARK:- Zoom Level
    var zoomIdx: Int {
        willSet {
            /// cap `zoomIndex` to valid indices
            let safeVal = min(max(newValue, 0), zoomLevels.count - 1)
            /// update `UserDefaults`
            WorkspaceManager.zoomIdx = safeVal
            objectWillChange.send()
        }
    }
    var zoomLevel: CGFloat {
        /// cap `zoomIndex` to valid indices
        zoomLevels[min(max(zoomIdx, 0), zoomLevels.count - 1)]
    }
    
    /// length of time interval visible in `GraphView`
    var interval: TimeInterval {
        .day / Double(zoomLevel)
    }
    
    let zoomLevels: [CGFloat] = [
        1.0, /// 24hr
        1.5, /// 16hr
        2.0, /// 12hr
        3.0, /// 8hr
        4.0, /// 6hr
        6.0, /// 4hr
        8.0, /// 3hr
        12.0,/// 2hr
        24.0 /// 1hr
    ]
}

extension ZeroDate {
    /**
     a short string marking the `start` and `end` of this week
     */
    var weekString: String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMdd")
        /// slightly adjust `end` so that it falls before midnight, into the previous day
        return "\(df.string(from: start)) – \(df.string(from: end - 1))"
    }
}
