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
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Button {
                            withAnimation { model.selected = .none }
                        } label: {
                            Image(systemName: "xmark")
                        }
                            .buttonStyle(PlainButtonStyle())
                        Text(model.selected?.entry.wrappedDescription ?? "[No Description]")
                            .font(.title)
                        Label(model.selected?.entry.projectName ?? StaticProject.noProject.name, systemImage: "folder.fill")
                        Label(model.selected?.entry.dur.toString() ?? placeholderTime, systemImage: "stopwatch")
                    }
                    Spacer()
                }
                    .padding()
                    .background(model.selected?.entry.color)
                    .matchedGeometryEffect(id: model.selected!, in: namespace)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
