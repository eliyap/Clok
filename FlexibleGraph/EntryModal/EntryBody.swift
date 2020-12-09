//
//  EntryBody.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 9/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryBody: View {
    
    let entry: TimeEntryLike
    
    var body: some View {
        VStack(alignment: .labelText) {
            Label {
                HStack {
                    start
                    Text("–")
                    end
                }
            } icon: {
                Image(systemName: "stopwatch")
            }
                .labelStyle(AlignedLabelStyle())
            Label(
                "\(entry.duration.toString())",
                systemImage: "hourglass.tophalf.fill"
            )
                .labelStyle(AlignedLabelStyle())
        }
            .padding(EntryFullScreenModal.sharedPadding)
    }
    
    var start: some View {
        Group {
            /// if either bound is not within this year, return full date (note: this covers the case where start / end year differ)
            if entry.start.year != Date().year || entry.end.year != Date().year {
                Text(entry.start.dftfShort)
            } else if entry.start.midnight != entry.end.midnight {
                /// if the end date differs from the start date, show both dates
                Text("\(entry.start.tfShort)")
                Text("\(entry.start.MMMdd)")
                    .foregroundColor(.secondary)
            } else {
                Text(entry.start.tfShort)
            }
        }
    }
    
    var end: some View {
        Group {
            /// if either bound is not within this year, return full date (note: this covers the case where start / end year differ)
            if entry.start.year != Date().year || entry.end.year != Date().year {
                Text(entry.start.dftfShort)
            } else {
                Text("\(entry.end.tfShort)")
                Text("\(entry.end.MMMdd)")
                    .foregroundColor(.secondary)
            }
        }
    }
}
