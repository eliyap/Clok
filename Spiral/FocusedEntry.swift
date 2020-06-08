//
//  FocusedEntry.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.07.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct FocusedEntry: View {
    @EnvironmentObject private var listRow:ListRow
    @State var entry : TimeEntry? = nil
    var body: some View {
        // wrapping group never disappears, unlike nullable SpiralPart
        Group {
            SpiralPart(entry ?? TimeEntry())?
            .stroke(Color.black, style: StrokeStyle(
                lineWidth: 5,
                lineCap: .round,
                lineJoin: .round
            ))
            
            .border(Color.black)
        }
        .onReceive(self.listRow.$entry, perform: {
            if let entry = $0 {
                self.entry = entry
            }
        })
        
    }
}

struct FocusedEntry_Previews: PreviewProvider {
    static var previews: some View {
        FocusedEntry()
    }
}
