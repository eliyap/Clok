//
//  LineGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineGraph: View {
    
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var zero: ZeroDate
    @State private var Interval: TimeInterval = dayLength / 2
    /// for now, show 7 days
    private let dayCount = 7.0
    
    var body: some View {
        ForEach(data.report.entries.within(interval: dayCount * dayLength, of: zero.date), id: \.id) { entry in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    
}
