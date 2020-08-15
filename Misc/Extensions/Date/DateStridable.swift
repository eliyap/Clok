//
//  DateStridable.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 13/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
extension Date: Strideable {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self.addingTimeInterval(n)
    }

    public func distance(to other: Date) -> TimeInterval {
        return other - self
    }
}
