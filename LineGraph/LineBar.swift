//
//  LineBar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineBar: View {
    
    typealias Bound = (min: Double, max: Double)
    
    @ObservedObject var entry: TimeEntry
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var listRow: ListRow
    @State private var opacity = 1.0
    @State private var offset = CGFloat.zero
    
    private var geo: GeometryProxy
    private let radius: CGFloat
    private let cornerScale = CGFloat(1.0/120.0);
    /// determines what proportion of available horizontal space to consume
    static let thicc = CGFloat(0.8)
    var bound: Bound
    
    var body: some View {
        return OptionalRoundRect(
            radius: radius,
            geo: geo,
            bound: bound
        )
            .foregroundColor(entry.wrappedColor)
            .opacity(opacity * (entry.matches(data.terms) ? 1 : 0.5) )
            .offset(x: .zero, y: offset)
            .onTapGesture { tapHandler() }
    }
    
    init?(
        with entry_: TimeEntry,
        geo geo_: GeometryProxy,
        bound bound_: Bound?
    ){
        guard let bound_ = bound_ else { return nil }
        entry = entry_
        geo = geo_
        /// adapt scale to taste
        radius = geo.size.height * cornerScale
        bound = bound_
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
