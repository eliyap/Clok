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
    
    var body: some View {
            ZStack{
                ForEach(self.report.entries, id: \.id) { entry in
                    EntrySpiral(
                        entry,
                        zeroTo:self.zero.frame.start
                    )
                }
            }
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
