//
//  DayBubbles.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct DayBubbles: View {
    
    @EnvironmentObject private var zero: ZeroDate
    private let cal = Calendar.current
    private let radius = CGFloat(3)
    
    var body: some View {
        GeometryReader { geo in
            ZStack() {
                ForEach(weekMN(), id: \.timeIntervalSince1970) { date in
                    Text(date.shortWeekday().uppercased())
                        .font(Font.system(size: ptSize(within: geo)))
                        .padding(ptSize(within: geo) / 5)
                        .background(
                            RoundedRectangle(
                                cornerRadius: ptSize(within: geo) / 2
                            ).foregroundColor(Color(UIColor.systemBackground))
                        )
                        .position(mnPos(for: cal.startOfDay(for: date), within: geo))
                        .transition(.opacity)
                }
            }
            
        }
    }
    
    /// calculates appropriate point size for display
    /// so that the text fits inside the spiral
    func ptSize(within geo: GeometryProxy) -> CGFloat {
        0.75 * stroke_width * (geo.size.width / frame_size)
    }
    
    /// generates the 6 midnights
    /// 7th one omitted because it covers too much of the center
    func weekMN() -> [Date] {
        var midnights = [Date]()
        let zeroMN = cal.startOfDay(for: zero.date)
        for date in stride(from: zeroMN, to: zeroMN - 6*dayLength, by: -dayLength){
            midnights.append(date)
        }
        return midnights
    }
    
    /// calculates the position of the given date on the spiral view
    func mnPos(for date: Date, within geo: GeometryProxy) -> CGPoint {
        /// calculate angle of date
        let weekAgo = zero.date - weekLength
        let theta = ((date - weekAgo) / dayLength) * (2*Double.pi)
        
        /**
         get the position on the spiral of that
         scale point to actual size
         rotate to align with spiral
         center the point
         convert to CGSize to satisfy offset type requirements
        */
        return spiralPoint(theta: theta, thicc: 0)
        .applying(CGAffineTransform(
            scaleX: geo.size.width / CGFloat(frame_size),
            y: geo.size.width / CGFloat(frame_size)
        ))
        /// slight downscale ensures all day bubbles are visually centered on the spiral
        /// literally just a lucky magic number
        .applying(CGAffineTransform(scaleX: 0.97, y: 0.97))
        .applying(CGAffineTransform(rotationAngle: CGFloat(zero.date.clockAngle24().radians)))
        .applying(CGAffineTransform(
            translationX: geo.size.width / 2,
            y: geo.size.height / 2
        ))
//        return CGSize(width: pt.x, height: pt.y)
    }
}

struct DayBubbles_Previews: PreviewProvider {
    static var previews: some View {
        DayBubbles()
    }
}
