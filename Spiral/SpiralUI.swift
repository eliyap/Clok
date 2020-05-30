//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct SpiralUI: View {
    @ObservedObject var report = Report()
    @EnvironmentObject var zero:ZeroDate
    
    var body: some View {
        VStack (alignment: .center, spacing: 0) {
            GeometryReader { geo in
                ZStack {
                    ForEach(self.report.entries, id: \.id) { entry in
                        EntrySpiral(
                            entry,
                            idx: self.report.entries.firstIndex(of: entry) ?? -1,
                            zeroTo:self.zero.frame.start
                        )
                    }
                }
                .frame(width: frame_size, height: frame_size)
                .scaleEffect(min(geo.size.width / frame_size, geo.size.height / frame_size))
            }
            DateBar()
            .padding()
        }
    }
    
    init(_ report:Report) {
        self.report = report
    }
    
}


struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        SpiralUI(Report())
    }
}
