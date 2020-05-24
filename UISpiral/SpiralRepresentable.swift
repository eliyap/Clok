//
//  SpiralRepresentable.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.22.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct SpiralRepresentable: UIViewRepresentable {
    
    var frame:WeekTimeFrame
    var segments:[EntrySpiral] = []
    
    let baseSpiral = LineSpiral(
        center: CGPoint(x: MAX_RADIUS, y: MAX_RADIUS),
        startRadius: 0,
        spacePerLoop: 1,
        startTheta: 0,
        endTheta: CGFloat(14 * Double.pi),
        thetaStep: 0.1
    )
    
    struct EntrySpiral {
        var entry:TimeEntry
        let startPhase:Double
        let endPhase:Double
        
        let lineWidth = 4.0
        
        var length:NSNumber {
            get {
                NSNumber(value:max(endPhase - startPhase - lineWidth, 0))
            }
        }
        
        init(entry:TimeEntry, frame:WeekTimeFrame) {
            self.entry = entry
            self.startPhase = frame.phase(entry.start)
            self.endPhase = frame.phase(entry.end)
        }
        
        func layer(_ path:CGPath) -> CAShapeLayer {
            let layer = CAShapeLayer()
            layer.path = path
            layer.strokeColor = entry.project_hex_color.cgColor()
            layer.lineWidth = CGFloat(min(lineWidth, length.doubleValue))
            layer.fillColor = nil
            layer.lineCap = .round
            layer.lineDashPattern = [length, weekSpiralLength]
            layer.lineDashPhase = -CGFloat(startPhase - lineWidth)
            
            return layer
        }
    }
    
    init(frame:WeekTimeFrame, entries:[TimeEntry]) {
        self.frame = frame
        entries.forEach() { entry in
            if frame.contains(entry) != .doesNot {
                self.segments.append(EntrySpiral(entry: entry, frame: frame))
                print(self.segments.last?.length)
            }
            
        }
    }
    
    
    func makeUIView(context: Context) -> UIView{
        let view = UIView()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("help")
        self.segments.forEach() {segment in
            uiView.layer.addSublayer(segment.layer(self.baseSpiral))
        }
    }
}
