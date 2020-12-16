//
//  EntryHeader.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension EntryFullScreenModal {
    
    var EntryHeader: some View {
        VStack(alignment: .leading) {
            /// clearance height for `ControlBar`
            Spacer()
                .frame(height: DismissalButton.ButtonSize + Self.sharedPadding * 2)
            
            ShieldedBinding($entryModel.entryDescription) { text, onCommit in
                TextField("Description", text: text, onCommit: onCommit)
                    .font(.title)
            }
            Text(entry.wrappedProject.name)
                .foregroundColor(entry.color)
        }
            .padding(Self.sharedPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                entry.color(in: colorScheme)
                    .matchedGeometryEffect(
                        id: geometry,
                        in: namespace,
                        isSource: false
                    )
            )
    }
}

