//
//  Int64_Optional.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// allow optional comparison quickly

extension Optional where Wrapped == Int {
    static func == (lhs: Int?, rhs: Int64?) -> Bool {
        switch rhs {
        case .none:
            return lhs == nil
        case .some(let r):
            return lhs == Int(r)
        }
    }
}

extension Optional where Wrapped == Int64 {
    static func == (lhs: Int64?, rhs: Int?) -> Bool {
        rhs == lhs
    }
}
