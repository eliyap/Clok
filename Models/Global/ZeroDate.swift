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
    init(){
        /// initialize to chosen start day
        /// usually, this will do nothing, but if user changed `firstDayOfWeek`, it should bring start up to speed
        start = WorkspaceManager.zeroStart.startOfWeek(day: WorkspaceManager.firstDayOfWeek)
        
        zoomIdx = WorkspaceManager.zoomIdx
        limitedStart = $start
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// default to 6 days before start of today
    /// ensures the default week includes today
    @Published var start: Date
    
    /// debounced zero start
    var limitedStart: AnyPublisher<Date, Never> = Just(Date()).eraseToAnyPublisher()
    
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
    
    @Published var dateChange: DateChange? = nil
    
    /**
     determine what kind of apperance / disappearance animation to use
     based on whether the anchor date was just moved forwards for backwards
     */
    var slideOver: AnyTransition {
        switch dateChange {
        case .fwrd:
            return .slideLeft
        case .back:
            return .slightRight
        default: // fallback option, fade in and out
            return .opacity
        }
    }
    
    // MARK:- Zoom Level
    @Published var zoomIdx: Int
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
        
        var startDate = df.string(from: start)
        var endDate = df.string(from: end)
        
        switch (start.year, end.year, Date().year) {
        /// if year differs from current year, append year
        case let (s, e, c) where s == e && s != c:
            endDate += " \(e)"
        /// if years differ, append both
        case let (s, e, _) where s != e:
            startDate += " \(s)"
            endDate += " \(e)"
        default:
            break
        }
        
        return startDate + " – " + endDate
    }
}
