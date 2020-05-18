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
    
    var body: some View {
        Spiral(theta1: entry.startTheta, theta2: entry.endTheta)
            // fill in with the provided color, or black by default
            // TODO: accomodate dark mode with an adaptive color here
            .fill(entry.project_hex_color)
            .gesture(TapGesture().onEnded(){_ in
                self.listRow.row = 1 // to be replaced by it's real index
                print("\(self.entry.description) - \(self.entry.project ?? "none")")
            })
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
