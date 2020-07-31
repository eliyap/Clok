//
//  LineBar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineBar: View {
    
    let entry: TimeEntry
    let begin: Date
    let size: CGSize
    
    @EnvironmentObject var listRow: ListRow
    @State private var opacity = 1.0
    @State private var offset = CGFloat.zero
    
    /// determines what proportion of available horizontal space to consume
    private let thicc = CGFloat(0.8)
    private let cornerScale = CGFloat(1.0/8.0)
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: size.height * cornerScale / CGFloat(LineGraph.dayCount)) /// adapt scale to taste
            .size(
                width: size.width * thicc / CGFloat(LineGraph.dayCount),
                height: size.height * CGFloat((entry.end - entry.start) / dayLength)
            )
            .offset(CGPoint(
                x: size.width / CGFloat(LineGraph.dayCount) * CGFloat((1.0 - thicc) / 2.0),
                y: size.height * CGFloat((entry.end - begin) / dayLength)
            ))
            .opacity(opacity)
            .offset(y: offset)
            .foregroundColor(entry.wrappedColor)
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
