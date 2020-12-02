//
//  EntryFullScreenModal.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension FlexibleGraph {
    var EntryFullScreenModal: some View {
        Rectangle()
            .foregroundColor(model.selected?.entry.color)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .matchedGeometryEffect(id: model.selected!, in: namespace)
    }
}
