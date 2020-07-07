//
//  LineBar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineBar: View {
    
    typealias Bound = (min: Double, max: Double, col: Int)
    
    @ObservedObject var entry: TimeEntry
    @EnvironmentObject private var zero: ZeroDate
    private var geo: GeometryProxy
    private let radius: CGFloat
    private let cornerScale = CGFloat(1.0/120.0);
    /// determines what proportion of available horizontal space to consume
    static let thicc = CGFloat(0.8)
    
    var body: some View {
        ForEach(GetBounds(), id: \.col){ bound in
            Bar(from: bound)
                .foregroundColor(entry.project.color)
        }
    }
    
    init(
        with entry_: TimeEntry,
        geo geo_: GeometryProxy
    ){
        entry = entry_
        geo = geo_
        /// adapt scale to taste
        radius = geo.size.height * cornerScale
    }
    
    func Bar(from bound: Bound) -> some View {
        let width = LineBar.thicc * geo.size.width / CGFloat(LineGraph.dayCount)
        var height = CGFloat(bound.max - bound.min) * geo.size.height
        /// increase height if bar falls out of bounds
        if bound.min == .zero { height += radius }
        if bound.max == 1.0 { height += radius }
        
        /// if rect falls below bound, drop it out to hide roundedness
        let x = geo.size.width * CGFloat(Double(bound.col) / Double(LineGraph.dayCount))
        let y = bound.min == .zero ? -radius : CGFloat(bound.min) * geo.size.height
        return RoundedRectangle(cornerRadius: radius)
            .size(CGSize(width: width, height: height))
            .position(
                x: x + geo.size.width / 2,
                y: y + geo.size.height / 2
            )
    }
    
    func GetBounds() -> [Bound] {
        var bounds = [Bound]()
        for i in 0..<LineGraph.dayCount {
            let begin = zero.date + (Double(i) * dayLength)
            guard entry.end > begin && entry.start < begin + zero.interval else { continue }
            bounds.append(Bound(
                max(0, (entry.start - begin) / zero.interval),
                min(1, (entry.end - begin) / zero.interval),
                col: i
            ))
        }
        return bounds
    }
}
