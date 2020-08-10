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
    
    let listPadding: CGFloat
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Summary")
                    .font(.title)
                    .bold()
                    .padding(.bottom, listPadding)
                HStack {
                    /// show Any Project as an empty circle
                    #warning("silenced")
//                    Image(systemName: StaticProject.any == data.terms.project ? "circle" : "largecircle.fill.circle")
//                        .foregroundColor(StaticProject.any == data.terms.project ? Color.primary : data.terms.project.wrappedColor)
//                    Text(data.terms.project.wrappedName)
//                        .bold()
//                    if data.terms.byDescription == .any {
//                        Text("Any Description")
//                            .foregroundColor(.secondary)
//                    } else if data.terms.byDescription == .empty {
//                        Text("No Description")
//                            .foregroundColor(.secondary)
//                    } else {
//                        Text(data.terms.description)
//                    }
                }
                StatDisplayView(
                    for: WeekTimeFrame(
                        start: zero.start,
                        entries: data.entries,
                        terms: data.terms
                    ),
                    prev: WeekTimeFrame(
                        start: zero.start - .week,
                        entries: data.entries,
                        terms: data.terms
                    )
                )
            }
            .padding(listPadding)
        }
    }
}
