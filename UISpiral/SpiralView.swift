//
//  SpiralView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.22.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SpiralView: View {
    var frame:WeekTimeFrame
    var entries:[TimeEntry]
    
    var body: some View {
        GeometryReader { geo in
            SpiralRepresentable(
                frame: self.frame,
                entries: self.entries
            ).transformEffect(CGAffineTransform(
                scaleX: min(geo.size.width / frame_size, geo.size.height / frame_size),
                y: min(geo.size.width / frame_size, geo.size.height / frame_size)))
        }
        
    }
}
