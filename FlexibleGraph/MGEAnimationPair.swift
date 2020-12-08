//
//  MGEAnimationPair.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 8/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    
    static let heroAnimationDuration = 0.4
    static let modalTransitionDuration = 0.2
    
    static let ModalTransition = AnyTransition.asymmetric(
        insertion: AnyTransition
            .opacity
            .animation(Animation
                .easeInOut(duration: Self.modalTransitionDuration)
                .delay(Self.heroAnimationDuration)
            ),
        removal: AnyTransition
            .opacity
            .animation(Animation
                .easeInOut(duration: Self.modalTransitionDuration)
            )
    )
}
