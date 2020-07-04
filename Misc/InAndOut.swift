//
//  InAndOut.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static let fastLinear = Animation.linear(duration: 0.25)
    
    static func inAndOut(edge: Edge) -> AnyTransition {
        return AnyTransition
            .move(edge: edge)
            .animation(AnyTransition.fastLinear)
            .combined(with: AnyTransition
                .opacity
                .animation(AnyTransition.fastLinear)
            )
    }
}
