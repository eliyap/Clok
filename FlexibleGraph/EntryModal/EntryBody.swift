//
//  EntryBody.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 9/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryBody: View {
    
    let isEditing: Bool
    @ObservedObject var model: EntryModel
    
    /// bounding width - label icon offset. supports my horrible horrible hackjob version of the `TagList` view
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
                "\(model.duration.toString())",
                /// When looking at the modal for a running timer, we should switch out for a running hourglass, and turn it over every few seconds
                systemImage: "hourglass.tophalf.fill"
            )
                .labelStyle(AlignedLabelStyle())
            
            Label {
//                TagList(tags: entry.tagStrings.sorted(), boundingWidth: width)
            } icon: {
                Image(systemName: "tag")
            }
                .labelStyle(AlignedLabelStyle())
            
            BillableToggle(isEditing: isEditing, billable: $model.billable)
        }
            .padding(EntryFullScreenModal.sharedPadding)
    }
    
    var StartTime: some View {
        Group {
            /// if either bound is not within this year, return full date (note: this covers the case where start / end year differ)
            if model.start.year != Date().year || model.end.year != Date().year {
                Text(model.start.dftfShort)
            } else if model.start.midnight != model.end.midnight {
                /// if the end date differs from the start date, show both dates
                Text("\(model.start.tfShort)")
                Text("\(model.start.MMMdd)")
                    .foregroundColor(.secondary)
            } else {
                Text(model.start.tfShort)
            }
        }
    }
    
    var EndTime: some View {
        Group {
            /// if either bound is not within this year, return full date (note: this covers the case where start / end year differ)
            if model.start.year != Date().year || model.end.year != Date().year {
                Text(model.start.dftfShort)
            } else {
                Text("\(model.end.tfShort)")
                Text("\(model.end.MMMdd)")
                    .foregroundColor(.secondary)
            }
        }
    }
}
