//
//  Clamp.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

func clamp<T>(_ val: T, between bounds: (T, T)) -> T where T:Comparable {
    precondition(bounds.0 < bounds.1, "Invalid Bounds for clamp!")
    return max(bounds.0, min(val, bounds.1))
}
