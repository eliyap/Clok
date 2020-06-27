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
    @State private var dateString = ""
    private var df = DateFormatter()
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Summary")
                    .font(.title)
                    .bold()
                Text(dateString)
                    .font(.subheadline)
                    .bold()
                    .onReceive(self.zero.$date, perform: { date in
                        /// set labels programatically so that ellipsis animation does NOT play when changing date
                        self.dateString = "\(self.df.string(from: date)) – \(self.df.string(from: date + weekLength))"
                    })
                HStack {
                    /// show Any Project as an empty circle
                    Image(systemName: data.terms.project == .any ? "circle" : "largecircle.fill.circle")
                        .foregroundColor(data.terms.project == .any ? Color.primary : data.terms.project.color)
                    Text(data.terms.project.name)
                        .bold()
                    if data.terms.byDescription == .any {
                        Text("Any Description")
                            .foregroundColor(.secondary)
                    } else if data.terms.byDescription == .empty {
                        Text("No Description")
                            .foregroundColor(.secondary)
                    } else {
                        Text(data.terms.description)
                    }
                }
                .onTapGesture {
                    self.data.searching = true
                }
                Divider()
                StatDisplayView(for: WeekTimeFrame(
                    start: self.zero.date,
                    entries: self.data.report.entries,
                    terms: self.data.terms
                ))
                Text("XX Total")
                Text("XX Per Day")
            }
            .padding()
        }
        .background(slightBG())
    }
    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    func Tab() -> some View {
        Rectangle()
            .frame(width: listLineInset)
            .foregroundColor(data.terms.project.color)
    }
    
    func Stat(label: String, symbol: String, text: Text) -> some View {
        Group {
            HStack{
                Text(label)
                Spacer()
                Image(systemName: symbol)
            }
            text
        }
    }
}
