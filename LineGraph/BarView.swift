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
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var listRow: ListRow
    @State private var opacity = 1.0
    @State private var offset = CGFloat.zero
    
    private var geo: GeometryProxy
    private let radius: CGFloat
    private let cornerScale = CGFloat(1.0/120.0);
    /// determines what proportion of available horizontal space to consume
    static let thicc = CGFloat(0.8)
    var bounds = [Bound]()
    
    var body: some View {
        ForEach(bounds, id: \.col){ bound in
            Bar(from: bound)
                .foregroundColor(entry.project.color)
        }
        .opacity(opacity * (entry.matches(data.terms) ? 1 : 0.5) )
        .offset(x: .zero, y: offset)
        .onTapGesture { tapHandler() }
    }
    
    init?(
        with entry_: TimeEntry,
        geo geo_: GeometryProxy,
        bounds bounds_: [Bound]
    ){
        entry = entry_
        geo = geo_
        /// adapt scale to taste
        radius = geo.size.height * cornerScale
        bounds = bounds_
        /// if there's nothing to draw, fail the initializer
        if bounds.count == 0 {
            return nil
        }
    }
    
    func Bar(from bound: Bound) -> some View {
        let x = geo.size.width * CGFloat(Double(bound.col) / Double(LineGraph.dayCount))
            /// add a margin to center the bars in frame
            + (1 - LineBar.thicc) * geo.size.width / CGFloat(2 * LineGraph.dayCount)
        let y = CGFloat(bound.min) * geo.size.height
        return OptionalRoundRect(
            clipBot: bound.max == .zero,
            clipTop: bound.min == .zero,
            radius: radius
        )
            .size(CGSize(
                width: LineBar.thicc * geo.size.width / CGFloat(LineGraph.dayCount),
                height: CGFloat(bound.max - bound.min) * geo.size.height
            ))
            .position(
                x: x + geo.size.width / 2,
                y: y + geo.size.height / 2
            )
    }
    
    // MARK: - Tap Handler
    func tapHandler() -> Void {
        /// scroll to entry in list
        listRow.entry = entry
        
        /// brief bounce animation, peak quickly & drop off slowly
        withAnimation(.linear(duration: 0.1)){
            /// drop the opacity to take on more BG color
            opacity -= 0.25
            /// slight jump
            offset -= geo.size.height / 40
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 0.3)){
                opacity = 1
                offset = .zero
            }
        }
    }
}
