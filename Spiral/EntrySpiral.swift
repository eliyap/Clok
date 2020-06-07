//
//  EntrySpiral.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.13.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntrySpiral: View {
    @ObservedObject var entry:TimeEntry = TimeEntry()
    @EnvironmentObject var listRow: ListRow
    @State private var opacity = 0.8
    @State private var scale = 1.0
    
    var body: some View {
        
        SpiralPart(
            thetaStart: entry.startTheta,
            thetaEnd: entry.endTheta,
            rotation: entry.rotate
        )?
//            .stroke(entry.project_hex_color, style: StrokeStyle(
//                lineWidth: 8.1,
//                lineCap: .round,
//                lineJoin: .round
//
//            ))
            .fill(entry.project_hex_color)
            .gesture(TapGesture().onEnded() {_ in
                /// pass selection to global variable
                self.listRow.entry = self.entry
                /// then deselect immediately
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self.listRow.entry = nil
                }
                
                /// brief bounce animation
                /// per Zero Punctuation advice, peak quickly then drop off slowly
                withAnimation(.linear(duration: 0.1)){
                    // drop the opacity to take on more BG color
                    self.opacity -= 0.25
                    /// make scale more pronounced closer to the center
                    self.scale += 1 / self.entry.endTheta
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.linear(duration: 0.3)){
                        self.opacity = 1
                        self.scale = 1
                    }
                }
            })
            .opacity(opacity)
        .scaleEffect(CGFloat(scale))
    }
    
    init? (_ entry:TimeEntry, zeroTo zeroDate:Date) {
        self.entry = entry
        self.entry.zero(zeroDate)
        guard self.entry.endTheta > 0 && self.entry.startTheta < MAX_RADIUS else { return nil }
    }
}

struct EntrySpiral_Previews: PreviewProvider {
    static var previews: some View {
        EntrySpiral(
            TimeEntry(),
            zeroTo: Date()
        )
    }
}
