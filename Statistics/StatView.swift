//
//  StatView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    @State private var search = SearchTerm(
        project: .any,
        description: "",
        byDescription: false
    )
    var body: some View {
        NavigationView {
            VStack {
                SearchView(search: self.$search)
                
                StatDisplayView(for: WeekTimeFrame(
                    start: self.zero.date,
                    entries: self.data.report.entries,
                    terms: self.search
                ))
                .navigationBarHidden(true)
                .navigationBarTitle("Summary", displayMode: .inline)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
}
