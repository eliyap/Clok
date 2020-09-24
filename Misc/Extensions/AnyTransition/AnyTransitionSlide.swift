//
//  AnyTransitionSlide.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static let slideLeft = AnyTransition.asymmetric(
        insertion: AnyTransition
            .move(edge: .trailing)
            .combined(with: .opacity),
        removal: AnyTransition
            .move(edge: .leading)
            .combined(with: .opacity)
    )
    static let slightRight = AnyTransition.asymmetric(
        insertion: AnyTransition
            .move(edge: .leading)
            .combined(with: .opacity),
        removal: AnyTransition
            .move(edge: .trailing)
            .combined(with: .opacity)
    )
}
