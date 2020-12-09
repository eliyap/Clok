//
//  LineDiff.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 9/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

extension FlexibleGraph {
    
    /// time to take a rolling average over
    static let rollingAvgDuration = TimeInterval.week
    
    /// get the next next interval and the previous previous interval
    static let secondDerivativeAdjustment = 2 * TimeInterval.day
    
    /// midnight: the starting datetime for this 24 hour period
    func stuff(
        midnight: Date
    ) -> Void {
        let superset = entries
//            .filter{$0.end > midnight + Double(1 - Self.castBack - 2) * .day}
//            /// 3 days to get today though the next next day
//            .filter{$0.start < midnight + 2 * .day}
//            .matching(terms: data.terms)
        
//        func subset(_ offset: Int) -> [TimeEntry] {
//            superset
//                /// castback accounts for the rolling average
//                .filter{$0.end > midnight - Double(Self.castBack + offset) * .day}
//                .filter{$0.start < midnight + Double(offset + 1) * .day}
//        }
//        
//        let 🔙🔙 = subset(-2)
//        let 🔙 = subset(-1)
//        let 🔝 = subset(0)
//        let 🔜 = subset(+1)
//        let 🔜🔜 = subset(+2)
        
        
    }
}
