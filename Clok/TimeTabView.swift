//
//  TimeTabView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct TimeTabView: View {
    @EnvironmentObject private var data: TimeData
    @EnvironmentObject private var zero: ZeroDate
    
    var body: some View {
        TabView {
            CustomTableView(self.data.report.entries.within(interval: weekLength, of: self.zero.date))
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Entries")
                }
            StatView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }
        }
    }
}
