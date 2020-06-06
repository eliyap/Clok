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
//    @State private var stroke:CGFloat = stroke_weight
    @State private var opacity:Double = 1
    
    var body: some View {
                
        Spiral(
            theta1: entry.startTheta,
            theta2: entry.endTheta,
            rotation: entry.rotate
        )
            .fill(entry.project_hex_color)
            
        .gesture(TapGesture().onEnded(){_ in
            /// pass selection to global variable
            self.listRow.entry = self.entry
            /// then deselect immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.listRow.entry = nil
            }
            
            /// brief bounce animation
            /// per Zero Punctuation advice, peak quickly then drop off slowly
            withAnimation(.linear(duration: 0.1)){
//                self.stroke += 2
                // drop the opacity to take on more BG color
                self.opacity -= 0.25
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 0.3)){
//                    self.stroke = stroke_weight
                    self.opacity = 1
                }
            }
        })
        .opacity(opacity)
    }
    
    init (_ entry:TimeEntry, zeroTo zeroDate:Date) {
        self.entry = entry
        self.entry.zero(zeroDate)
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
