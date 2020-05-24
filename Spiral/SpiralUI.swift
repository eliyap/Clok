//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct SpiralUI: View {
    @ObservedObject var report = Report()
    @State var zero:Date = Date().addingTimeInterval(TimeInterval(-86400 * 7))
    @State var dummy = 10
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                ForEach(self.report.entries, id: \.id) { entry in
                    EntrySpiral(
                        entry,
                        zeroTo:self.zero
                    )
                }
                .onAppear(){
                    var timer = Timer.scheduledTimer(
                        withTimeInterval: 0.02,
                        repeats: true,
                        block: { _ in
                            self.zero = self.zero.addingTimeInterval(-1)
                        }
                    )
                }
            }
            .border(Color.black)
            .frame(width: frame_size, height: frame_size)
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
