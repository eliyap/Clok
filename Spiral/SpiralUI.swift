//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct SpiralUI: View {
    @ObservedObject var report = Report()
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                ForEach(self.report.entries, id: \.id) { entry in
                    EntrySpiral(entry, Date().addingTimeInterval(TimeInterval(-86400 * 7)))
                }
            }
            .border(Color.black)
            .frame(width: frame_size, height: frame_size)
            .scaledToFill()
                
            .scaleEffect(min(geo.size.width / frame_size, geo.size.height / frame_size))
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
