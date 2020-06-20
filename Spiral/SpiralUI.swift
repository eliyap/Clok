//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct SpiralUI: View {
    @ObservedObject var report:Report
    @EnvironmentObject var zero:ZeroDate
    @State private var rotate = Angle()
    
    var body: some View {
        ZStack {
            ForEach(self.report.entries, id: \.id) { entry in
                EntrySpiral(
                    entry,
                    zeroTo:self.zero.date
                )
            }
        }
        .onReceive(self.zero.$weekSkip, perform: { dxn in
            /// when a week skip command is received,
            /// perform a 360 degree barell roll animation,
            /// then reset the flag
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
    
    init(_ _report:Report) {
        report = _report
    }
    
    
}


struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        SpiralUI(Report())
    }
}
