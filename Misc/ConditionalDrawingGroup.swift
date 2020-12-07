//
//  ConditionalDrawingGroup.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct conditionalDrawingGroup: ViewModifier {
    
    let condition: Bool
    
    func body(content: Content) -> some View {
        Group {
            if condition {
                content.drawingGroup()
            } else {
                content
            }
        }
    }
}

