//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI

struct SpiralUI: View {
    @State private var report = Report()
    
    var body: some View {
        ZStack {
            ForEach(report.entries, id: \.id) { entry in
                Spiral(
                    theta1: entry.startTheta,
                    theta2: entry.endTheta
                ).fill(Color.red)
            }
        }
        .padding()
        .border(Color.black)
        .frame(width: frame_size, height: frame_size)
        .scaleEffect(CGFloat(13.5), anchor: .center)
        .onAppear{
            self.loadData()
        }
    }
    
    func loadData() {
        var report = Report([:])
        DispatchQueue.global(qos: .utility).async {
            
            // assemble request URL (page is added later)
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd" // ISO 8601 format, day precision
            
            let since = df.string(from: Date().addingTimeInterval(TimeInterval(-86400 * 365))) // grab 365 days...
            let until = df.string(from: Date())                                                // ...from today
            
            // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
            let base_url = "https://toggl.com/reports/api/v2/"
            let api_string = "\(base_url)details?" + [
                "user_agent=\(user_agent)",    // identifies my app
                "workspace_id=\(myWorkspace)", // provided by the User
                "since=\(since)",
                "until=\(until)"
                ].joined(separator: "&")
            
            let result = toggl_request(api_string: api_string, token: myToken)
            
            DispatchQueue.main.async {
                switch result {
                case let .success(myReport):
                    self.report = myReport
                    #if DEBUG
                    print("Fetched \(report.entries.count) entries in total")
                    print(report.entries.max(){$0.start > $1.start}?.start)
                    print(report.entries.min(){$0.start > $1.start}?.start)
                    #endif
                case .failure(.request):
                    // temporary micro-copy
                    print("We weren't able to fetch your data. Maybe the internet is down?")
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}


struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        SpiralUI()
    }
}
