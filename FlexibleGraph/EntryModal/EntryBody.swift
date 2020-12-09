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
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            Label {
                HStack {
                    StartTime
                    Text("–")
                    EndTime
                }
            } icon: {
                Image(systemName: "stopwatch")
            }
                .labelStyle(AlignedLabelStyle())
            Label(
                "\(entry.duration.toString())",
                /// When looking at the modal for a running timer, we should switch out for a running hourglass, and turn it over every few seconds
                systemImage: "hourglass.tophalf.fill"
            )
                .labelStyle(AlignedLabelStyle())
            Label {
                TagList(tags: entry.tagStrings.sorted(), boundingWidth: width)
            } icon: {
                Image(systemName: "tag")
            }
                .labelStyle(AlignedLabelStyle())
            Text("Test Thing")
        }
            .padding(EntryFullScreenModal.sharedPadding)
    }
    
    var StartTime: some View {
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
    
    var EndTime: some View {
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
