//
//  ConditionalMatchedGeometryEffect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
struct conditionalMatchedGeometryEffect<T>: ViewModifier where T:Hashable {
    var condition: Bool
    var id: T
    var namespace: Namespace.ID
    func body(content: Content) -> some View {
        Group {
            if condition {
                content
            } else {
                content.matchedGeometryEffect(id: id, in: namespace)
            }
        }
    }
}
