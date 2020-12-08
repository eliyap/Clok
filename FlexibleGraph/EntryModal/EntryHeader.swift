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
        VStack(alignment: .labelText) {
            Spacer()
                .frame(height: DismissalButton.ButtonSize + Self.sharedPadding * 2)
            Text(entry.entryDescription)
                .font(.title)
            Label(entry.projectName, systemImage: "folder.fill")
                .labelStyle(AlignedLabelStyle())
            Label(entry.duration.toString(), systemImage: "stopwatch")
                .labelStyle(AlignedLabelStyle())
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
