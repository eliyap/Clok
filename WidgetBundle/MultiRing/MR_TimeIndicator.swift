//
//  MR_TimeIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 27/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension ProjectRing {
    /// shows the amount of time spent on this project
    var TimeIndicator: some View {
        /// (ab)use `Group` to erase type
        Group {
            switch hours {
            /// signals `.empty`
            case -1:
                EmptyRing
            case 0:
                Text("\(mins)m")
                    .font(.system(size: minuteFont, design: .rounded))
                    .bold()
                    .foregroundColor(highContrast)
            default:
                Text(String(format: "%d:%02d", hours, mins))
                    .font(.system(size: hourFont, design: .rounded))
                    .bold()
                    .foregroundColor(highContrast)
            }
        }
    }
}

// MARK: - Size Based Properties
extension ProjectRing {
    var minuteFont: CGFloat {
        switch size {
        case .small:
            return 12
        default:
            return 20
        }
    }
    var hourFont: CGFloat {
        switch size {
        case .small:
            /// shrink slightly if hours are 2 digits
            return hours >= 10
                ? 14
                : 12
        default:
            /// shrink slightly if hours are 2 digits
            return hours >= 10
                ? 28
                : 24
        }
    }
}
