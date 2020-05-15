//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct SpiralUI: View {
    @State private var report = Report()
    
    var body: some View {
        ZStack {
            ForEach(report.entries, id: \.id) { entry in
                EntrySpiral(entry, Date().addingTimeInterval(TimeInterval(-86400 * 7)))
            }
        }
        .border(Color.black)
        .frame(width: frame_size, height: frame_size)
        .scaledToFill()
        .onAppear{
            self.loadData()
        }
    }
    
}


struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        SpiralUI()
    }
}
