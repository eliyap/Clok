//
//  MiscellaneousConstants.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

enum Constants {
    static let NoProjectHex = "#B5BCC0" /// copied from https://github.com/toggl/mobileapp/blob/e2914194c436374b2809f6ed864e26756da091a4/Toggl.Core/Helper/Colors.cs
}

enum CastError: Error {
    /// throw this error when an optional downcast `as?` fails
    case failedCast
}
