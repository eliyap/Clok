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
        NSSortDescriptor(key: "\(\TimeEntry.wrappedStart.timeIntervalSince1970)", ascending: true)
    ]) var entries: FetchedResults<TimeEntry>
    
    var body: some View {
        ZStack {
            Clockhands().allowsHitTesting(false)
            /// dummy shape prevents janky animation when there are no entries
            Circle().stroke(style: StrokeStyle(lineWidth: 0))
            ForEach(entries, id: \.id) { entry in
//                #warning("silenced type error")
                EntrySpiral(entry)
            }
            DayBubbles().allowsHitTesting(false)
        }
        .onReceive(self.zero.$weekSkip, perform: { dxn in
            /**
             when a week skip command is received,
             perform a 360 degree barell roll animation,
             then reset the flag
             */
            
            switch dxn {
            case .fwrd:
                self.rotate += Angle(degrees: 360)
                self.zero.weekSkip = nil
            case .back:
                self.rotate -= Angle(degrees: 360)
                self.zero.weekSkip = nil
            default:
                return
            }
        })
        .rotationEffect(self.rotate)
        .animation(.spring())
        .aspectRatio(1, contentMode: .fit)
        .drawingGroup()
    }
}
