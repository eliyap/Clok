//
//  MGEAnimationPair.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    
    /// duration of swooshy screen filling animation
    static let heroAnimationDuration = 0.4
    
    /// duration of opacity animation for `EntryFullScreenModal`
    static let modalTransitionDuration = 0.2
    
    static let ModalTransition = AnyTransition.asymmetric(
        insertion: AnyTransition
            .opacity
            .animation(Animation
                .easeInOut(duration: Self.modalTransitionDuration)
                /// wait for swoosh to finish first
                .delay(Self.heroAnimationDuration)
            ),
        removal: AnyTransition
            .opacity
            .animation(Animation
                .easeInOut(duration: Self.modalTransitionDuration)
            )
    )
}
