//
//  TimeTabView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct TimeTabView: View {
    @ObservedObject var report:Report
    @EnvironmentObject var zero:ZeroDate
    
    var body: some View {
        TabView {
            CustomTableView(self.report.entries.within(interval: weekLength, of: self.zero.date))
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Entries")
                }
            StatView(for: WeekTimeFrame(
                start: self.zero.date,
                entries: self.report.entries,
                terms: SearchTerm(
                    project: "Sleep",
                    description: "",
                    byProject: true,
                    byDescription: false
                )
            ))
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }
        }
    }
}

struct TimeTabView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTabView(report: Report())
    }
}
