//
//  Badge.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import SwiftUI



struct Badge: View {
    var body: some View {
        
        ZStack {
            //            ForEach(entries, id: \.id){ entry in
            //                Spiral(
            //                    theta1: entry.startTheta,
            //                    theta2: entry.endTheta
            //                ).fill(Color.red)
            //
            //            }
            
            Spiral(
                theta1: entry[0].startTheta,
                theta2: entry[0].endTheta
            ).fill(Color.red)
        }
        .frame(width: frame_size, height: frame_size)
        .scaleEffect(CGFloat(3.5), anchor: .center)
        .onAppear{
            var report: Report!
            DispatchQueue.global(qos: .utility).async {
                
                // assemble request URL (page is added later)
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd" // ISO 8601 format, day precision
                
                let since = df.string(from: Date().addingTimeInterval(TimeInterval(-86400 * 365)))
                let until = df.string(from: Date())
                
                // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
                let base_url = "https://toggl.com/reports/api/v2/"
                let detailsURL = URL(string:"\(base_url)details?" + [
                    "user_agent=\(user_agent)",    // identifies my app
                    "workspace_id=\(myWorkspace)", // provided by the User
                    "since=\(since)",              // grab 365 days...
                    "until=\(until)"               // ...from today
                    ].joined(separator: "&"))!
                
                let result = toggl_request(detailsURL: detailsURL, token: myToken)

                DispatchQueue.main.async {
                    switch result {
                    case let .success(myReport):
                        report = myReport
                    case let .failure(error):
                        print(error)
                    }
                }
            }
        }
    }
}


struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
