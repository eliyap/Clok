//
//  LineEntry.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.15.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineEntry: View {
    var entry = TimeEntry()
    
    let df = DateFormatter()
    
    init(_ entry:TimeEntry){
        self.entry = entry
        df.dateStyle = .none
        df.timeStyle = .short
    }
    
    var body: some View {
        HStack{
            Rectangle()
                .fill(entry.project_hex_color)
                .frame(width:15)
            VStack(alignment: .leading) {
                if entry.project != nil {
                    Text(entry.project ?? "")
                        .foregroundColor(entry.project_hex_color)
                }
                if entry.description.count > 0 {
                    Text(entry.description)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                if entry.description.count == 0 && entry.project == nil {
                    // fallback when nothing was set
                    Text("No Description")
                        .foregroundColor(Color.gray)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                if entry.dur < 60 {
                    // fix formatting of time < 1 minute
                    Text("00:\(String(format: "%02d", Int(entry.dur)))")
                } else {
                    Text("\(DateComponentsFormatter().string(from: entry.dur) ?? "No Duration")")
                }
                Text("\(df.string(from: entry.start)) – \(df.string(from: entry.end))")
                    .foregroundColor(Color.secondary)
                    .font(.subheadline)
            }
        }
    }
}

struct LineEntry_Previews: PreviewProvider {
    static var previews: some View {
        LineEntry(TimeEntry())
    }
}
