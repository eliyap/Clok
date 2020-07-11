//
//  EntrySpiral.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.13.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntrySpiral: View {
    @ObservedObject var entry: OldTimeEntry
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var listRow: ListRow
    @State private var opacity = 1.0
    @State private var scale = 1.0
    
    var body: some View {
        
        SpiralPart(entry)?
            .fill(entry.project.color)
            // goes transparent when filtered out
            .opacity(opacity * (entry.matches(data.terms) ? 1 : 0.5) )
            .scaleEffect(CGFloat(scale))
            .onTapGesture { tapHandler() }
            
    }
    
    /// do not render view if it is outside 1 week range
    init? (_ entry:OldTimeEntry, zeroTo zeroDate:Date) {
        self.entry = entry
        self.entry.zero(zeroDate)
        guard self.entry.spiralEnd > 0 && self.entry.spiralStart < 1 else { return nil }
    }
    
    // MARK: - Tap Handler
    func tapHandler() -> Void {
        /// scroll to entry in list
        listRow.entry = entry
        
        /// brief bounce animation, peak quickly & drop off slowly
        withAnimation(.linear(duration: 0.1)){
            /// drop the opacity to take on more BG color
            opacity -= 0.25
            /// scale more when closer to the center
            scale += 0.075 / Double(entry.spiralEnd.squareRoot())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 0.3)){
                opacity = 1
                scale = 1
            }
        }
    }
}
