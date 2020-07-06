//
//  LineBar.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineBar: View {
    
    @ObservedObject var entry: TimeEntry
    @EnvironmentObject private var zero: ZeroDate
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    init?(with entry_: TimeEntry, interval: TimeInterval){
        entry = entry_
        guard entry.withinTime(lowerBound: zero.date, interval: interval) else {
            return nil
        }
    }
}
