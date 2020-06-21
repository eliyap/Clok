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
    
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = 0
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("Second View")) {
                    Text("Hello, World!")
                }
                Picker(selection: $selectedColor, label: Text("Please choose a color")) {
                   ForEach(0 ..< colors.count) {
                      Text(self.colors[$0])
                   }
                }
                .pickerStyle(DefaultPickerStyle())
                Text("You selected: \(colors[selectedColor])")
                StatDisplayView(for: WeekTimeFrame(
                    start: self.zero.date,
                    entries: self.data.report.entries,
                    terms: SearchTerm(
                        project: "Sleep",
                        description: "",
                        byProject: true,
                        byDescription: false
                    )
                ))
            }
                /// hide nav bar
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
}
