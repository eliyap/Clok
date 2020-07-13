//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct SpiralUI: View {
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var zero: ZeroDate
    @State private var rotate = Angle()
    @FetchRequest(entity: TimeEntry.entity(), sortDescriptors: [
//        NSSortDescriptor(key: "\(\TimeEntry.wrappedStart.timeIntervalSince1970)", ascending: true)
    ]) var entries: FetchedResults<TimeEntry>

    var body: some View {
        ZStack {
            Clockhands().allowsHitTesting(false)
            /// dummy shape prevents janky animation when there are no entries
            Circle().stroke(style: StrokeStyle(lineWidth: 0))
            ForEach(entries, id: \.id) { entry in
                if (entry.getDimensions(zero: zero.date).start < 1 && entry.getDimensions(zero: zero.date).end > 1) {
                    EntrySpiral(entry)
                }
            }
            DayBubbles().allowsHitTesting(false)
        }
        .onReceive(zero.$weekSkip, perform: { dxn in
            /**
             when a week skip command is received,
             perform a 360 degree barell roll animation,
             then reset the flag
             */
            
            switch dxn {
            case .fwrd:
                rotate += Angle(degrees: 360)
                zero.weekSkip = nil
            case .back:
                rotate -= Angle(degrees: 360)
                zero.weekSkip = nil
            default:
                return
            }
        })
        .rotationEffect(rotate)
        .animation(.spring())
        .aspectRatio(1, contentMode: .fit)
        .drawingGroup()
    }
}
