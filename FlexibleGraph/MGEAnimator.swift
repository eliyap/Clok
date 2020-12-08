//
//  MGEAnimator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 7/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    var MGEAnimator: some View {
        Group {
            (
                passthroughSelected != nil
                    ? Color(UIColor.secondarySystemBackground)
                    : .clear
            )
                .matchedGeometryEffect(
                    id: passthroughGeometry?.mirror ?? NamespaceModel.none,
                    /// switch namespaces when entry is selected  / de-selected
                    in: model.selected == nil ? graphNamespace : modalNamespace,
                    isSource: false
                )
            
            (passthroughSelected?.color ?? .clear)
                .matchedGeometryEffect(
                    id: passthroughGeometry ?? NamespaceModel.none,
                    /// switch namespaces when entry is selected  / de-selected
                    in: model.selected == nil ? graphNamespace : modalNamespace,
                    isSource: false
                )
        }
            .transition(.identity)
            /** Passes Changes on, but `withAnimation`
             The key to this approach is that after a `TimeEntry` is selected,
             the view instantly (without animation) snaps to the `TimeEntry`,
             then it switches `Namespace`s and targets `EntryFullScreenModal` to create the animation.
             It has the advantage of being `ZStack`ed above the graph, and does not clip behind any other entries
             */
            .onChange(of: passthroughSelected) { newSelection in
                withAnimation {
                    model.selected = newSelection
                }
                
            }
            .onChange(of: passthroughGeometry) { newGeometry in
                withAnimation {
                    model.geometry = newGeometry
                }
            }
    }
}
