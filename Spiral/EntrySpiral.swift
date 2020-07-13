//
//  EntrySpiral.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.13.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntrySpiral: View {
    @ObservedObject var entry: TimeEntry
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var listRow: ListRow
    @State private var opacity = 1.0
    @State private var scale = 1.0
    
    var body: some View {
        SpiralPart(entry: entry, zero: zero.date)?
            .fill(entry.wrappedColor)
            // goes transparent when filtered out
            .opacity(opacity * (entry.matches(data.terms) ? 1 : 0.5) )
            .scaleEffect(CGFloat(scale))
            .onTapGesture { tapHandler() }
    }
    
    /// do not render view if it is outside 1 week range
    init? (_ entry: TimeEntry) { self.entry = entry }
    
    // MARK: - Tap Handler
    func tapHandler() -> Void {
        /// scroll to entry in list
        listRow.entry = entry
        
        /// brief bounce animation, peak quickly & drop off slowly
        withAnimation(.linear(duration: 0.1)){
            /// drop the opacity to take on more BG color
            opacity -= 0.25
            /// scale more when closer to the center
            scale += 0.075 / Double(entry.getDimensions(zero: zero.date).end.squareRoot())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 0.3)){
                opacity = 1
                scale = 1
            }
        }
    }
}
