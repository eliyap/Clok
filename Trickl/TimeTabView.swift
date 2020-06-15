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
            CustomTableView(self.zero.date.withinWeekOf(self.report.entries))
                .tabItem() {
                    Image(systemName: "list.bullet")
                    Text("Entries")
                }
        }
    }
}

struct TimeTabView_Previews: PreviewProvider {
    static var previews: some View {
        TimeTabView(report: Report())
    }
}
