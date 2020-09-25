//
//  Mod.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension CGFloat {
    func mod(_ divisor: CGFloat) -> CGFloat {
        self - CGFloat(Int(self/divisor)) * divisor
    }
}

extension Double {
    func mod(_ divisor: Double) -> Double {
        self - Double(Int(self/divisor)) * divisor
    }
}
