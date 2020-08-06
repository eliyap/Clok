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
    let days: Int
    let height: CGFloat
    
    /// determines what proportion of available horizontal space to consume
    private let thicc = CGFloat(0.8)
    private let cornerScale = CGFloat(1.0/18.0)
    
    init(
        entry: TimeEntry,
        begin: Date,
        size: CGSize,
        days: Int
    ){
        self.entry = entry
        self.begin = begin
        self.size = size
        self.days = days
        
        let start = max(entry.start, begin)
        let end = min(entry.end, begin + Double(days) * dayLength)
        height = size.height * CGFloat((end - start) / (dayLength * Double(days)))
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: size.width * cornerScale) /// adapt scale to taste
            .frame(
                width: size.width * thicc,
                height: height
            )
            .foregroundColor(entry.wrappedColor)
    }
}
