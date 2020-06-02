//
//  CGPointExtension.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.01.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension CGPoint {
    func magnitude() -> CGFloat {
        (x*x + y*y).squareRoot()
    }
}
