//
//  Between.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension Comparable {
    /// Returns true if `val` lies between the bounds (exclusive)
    /// - Parameters:
    ///   - lower: lower bound. val must be strictly greater than this to return true
    ///   - upper: upper bound. val must be strictly less than this to return true
    /// - Returns: `Bool`
    func isBetween(_ lower: Self, _ upper: Self) -> Bool {
        lower < self && self < upper
    }
    
    /// Returns true if `val` lies between the bounds (inclusive)
    /// - Parameters:
    ///   - lower: lower bound. val must be greater than or equals to this to return true
    ///   - upper: upper bound. val must be less than or equals to this to return true
    /// - Returns: `Bool`
    func isWithin(_ lower: Self, _ upper: Self) -> Bool {
        lower <= self && self <= upper
    }
}
