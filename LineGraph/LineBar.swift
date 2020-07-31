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
    @EnvironmentObject var listRow: ListRow
    @State private var opacity = 1.0
    @State private var offset = CGFloat.zero
    
    private var size: CGSize
    private let cornerScale = CGFloat(1.0/18.0)
    
    /// determines what proportion of available horizontal space to consume
    static let thicc = CGFloat(0.8)
    var bound: Bound
    
    init?(
        entry: TimeEntry,       /// time entry to consider
        begin: Date,            /// beginning of the time interval to consider
        size: CGSize
    ){
        self.bound = (
            max(0, (entry.start - begin) / dayLength),
            min(1, (entry.end - begin) / dayLength)
        )
        
        self.entry = entry
        self.size = size
    }
    
    var body: some View {
        OptionalRoundRect(
            radius: size.height * cornerScale / CGFloat(LineGraph.dayCount), /// adapt scale to taste
            geoSize: size,
            bound: bound
        )
            .foregroundColor(entry.wrappedColor)
            .offset(x: .zero, y: offset)
            .onTapGesture { tapHandler() }
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
            offset -= size.height / 40
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 0.3)){
                opacity = 1
                offset = .zero
            }
        }
    }
}
