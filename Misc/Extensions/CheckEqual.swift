//
//  CheckEqual.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 22/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

enum EqualityError: Error {
    case unequal
}

/// If two values are unequal, throw an error.
/// Unlike `assert(a == b)`, this may be caught and handled.
/// - Throws: `EqualityError.unequal`
func check_equal<T: Equatable>(_ lhs: T, _ rhs: T) throws -> Void {
    if lhs != rhs {
        throw EqualityError.unequal
    }
}

