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
    private let radius = CGFloat(7)
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                ForEach(weekMN(), id: \.timeIntervalSince1970) { date in
                    Text((date.shortWeekday()).uppercased())
                        .font(.footnote)
                        .padding(radius / 2)
                        .background(RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(Color(UIColor.systemBackground))
                        )
                        .offset(mnPos(for: cal.startOfDay(for: date), within: geo))
                        .alignmentGuide(HorizontalAlignment.leading, computeValue: { d in
                            return d[HorizontalAlignment.center] + d.width
                        })
                        .alignmentGuide(VerticalAlignment.top, computeValue: { d in
                            return d[VerticalAlignment.top]
                        })
                }
            }
            
        }
    }
    
    /// generates the 7 midnights covered by the past week
    func weekMN() -> [Date] {
        var midnights = [Date]()
        let zeroMN = cal.startOfDay(for: zero.date)
        for date in stride(from: zeroMN, to: zeroMN - weekLength, by: -dayLength){
            midnights.append(date)
        }
        return midnights
    }
    
    /// calculates the position of the given date on the spiral view
    func mnPos(for date: Date, within geo: GeometryProxy) -> CGSize {
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
        let pt = spiralPoint(theta: theta, thicc: Double(stroke_width))
        .applying(CGAffineTransform(
            scaleX: geo.size.width / CGFloat(frame_size),
            y: geo.size.width / CGFloat(frame_size)
        ))
        .applying(CGAffineTransform(rotationAngle: CGFloat(zero.date.clockAngle24().radians)))
        .applying(CGAffineTransform(
            translationX: geo.size.width / 2,
            y: geo.size.height / 2
        ))
        return CGSize(width: pt.x, height: pt.y)
    }
}

struct DayBubbles_Previews: PreviewProvider {
    static var previews: some View {
        DayBubbles()
    }
}
