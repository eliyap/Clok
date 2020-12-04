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
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: .zero) {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionHeaders) {
                        Section(header: Button {
                            withAnimation { showEntry = false }
                        } label: {
                            Image(systemName: "xmark")
                        }
                            .buttonStyle(PlainButtonStyle())
                            .padding()
                            .frame(width: geo.size.width, alignment: .leading)
                            .background(Color(UIColor.secondarySystemFill))
                        ) {
                            VStack(alignment: .leading) {
                                Text(model.selected?.entry.wrappedDescription ?? "[No Description]")
                                    .font(.title)
                                Label(model.selected?.entry.projectName ?? StaticProject.noProject.name, systemImage: "folder.fill")
                                Label(model.selected?.entry.dur.toString() ?? placeholderTime, systemImage: "stopwatch")
                                Spacer()
                            }
                                .padding()
                                .frame(width: geo.size.width, alignment: .leading)
                                .background(model.selected?.entry.color)
                            
                        }
                        VStack {
                            Label(model.selected?.entry.projectName ?? StaticProject.noProject.name, systemImage: "folder.fill")
                            Label(model.selected?.entry.dur.toString() ?? placeholderTime, systemImage: "stopwatch")
                            Spacer()
                        }
                            .padding()
                    }
                        .background(Color.background)
                        .matchedGeometryEffect(id: model.selected!, in: namespace, isSource: showEntry)
                }
            }
        }
            .background(Color(UIColor.systemGray5))
    }
}
