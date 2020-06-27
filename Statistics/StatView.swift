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
    private var df = DateFormatter()
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Summary")
                    .font(.title)
                    .bold()
                Text("\(df.string(from: zero.date)) – \(df.string(from: zero.date + weekLength))")
                    .font(.subheadline)
                    .bold()
                    
                VStack(alignment: .leading) {
                    HStack {
                        Tab()
                        Text(data.terms.project.name)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Tab()
                        if data.terms.byDescription == .any {
                            Text("Any Description")
                                .foregroundColor(.secondary)
                        } else if data.terms.byDescription == .empty {
                            Text("No Description")
                                .foregroundColor(.secondary)
                        } else {
                            Text(data.terms.description)
                        }
                        Spacer()
                        
                    }
                }
                HStack{
                    Text("Started Around")
                    Spacer()
                    Image(systemName: "sun.dust.fill")
                }
                HStack{
                    Text("Ended Around")
                    Spacer()
                    Image(systemName: "moon.stars.fill")
                }
                HStack{
                    Text("Hours Logged")
                    Spacer()
                    Image(systemName: "hourglass.tophalf.fill")
                }
                Text("XX Total")
                Text("XX Per Day")
                StatDisplayView(for: WeekTimeFrame(
                    start: self.zero.date,
                    entries: self.data.report.entries,
                    terms: self.data.terms
                ))

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
}
