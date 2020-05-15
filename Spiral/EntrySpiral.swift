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
    var body: some View {
        Spiral(theta1: entry.startTheta, theta2: entry.endTheta)
            // fill in with the provided color, or black by default
            // TODO: accomodate dark mode with an adaptive color here
            .fill(Color.init(hex: entry.project_hex_color ?? "#000000"))
            .gesture(TapGesture().onEnded(){_ in
                print("\(self.entry.description) - \(self.entry.project ?? "none")")
            })
    }
    
    init (_ entry:TimeEntry, _ zeroDate:Date) {
        self.entry = entry
        self.entry.zero(zeroDate)
    }
}

struct EntrySpiral_Previews: PreviewProvider {
    static var previews: some View {
        EntrySpiral(TimeEntry(), Date())
    }
}
