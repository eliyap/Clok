//
//  EntryBody.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 9/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryBody: View {
    
    @ObservedObject var model: EntryModel
    
    /// bounding width - label icon offset. supports my horrible horrible hackjob version of the `TagList` view
    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            //MARK:- Date Segment
            Label {
                HStack {
                    Button(action: setField(to: .start)) { StartTime }
                    Text("–")
                    Button(action: setField(to: .end)) { EndTime }
                }
            } icon: {
                Image(systemName: "stopwatch")
            }
                .labelStyle(AlignedLabelStyle())
            
            //MARK:- Duration Segment
            Label(
                "\(model.duration.toString())",
                /// When looking at the modal for a running timer, we should switch out for a running hourglass, and turn it over every few seconds
                systemImage: "hourglass.tophalf.fill"
            )
                .labelStyle(AlignedLabelStyle())
            
            //MARK:- Tags Segment
            Label {
                TagList(tags: model.tagStrings.sorted(), boundingWidth: width)
            } icon: {
                Image(systemName: "tag")
            }
                .labelStyle(AlignedLabelStyle())
                .onTapGesture(perform: setField(to: .tags))
            
            BillableToggle(billable: $model.billable)
        }
            .padding(EntryFullScreenModal.sharedPadding)
    }
    
    /// construct a simple shorthand to set `field` with our preferred animation
    func setField(to field: EntryModel.Field) -> () -> Void {
        {
            withAnimation(PropertyEditView.animation) {
                model.field = field
            }
        }
    }
}

// MARK:- Start & End Times
/// try to conceal non-useful / redundant information where possible and natural, e.g.
/// - second copy of the same date (8-10am on the 16th of Nov)
/// - the year if entry was this year
extension EntryBody {
    
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
