//
//  ContentView.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var data: TimeData
    
    /// indicates whether we are finished loading data
    @State var loaded = false
    
    var body : some View {
        ZStack {
            GeometryReader { geo in
                if geo.size.width > geo.size.height {
                    /// landscape mode
                    HStack(spacing: 0) {
                        ContentGroupView(
                            heightLimit: geo.size.height,
                            widthLimit:geo.size.height
                        )
                    }
                } else {
                    /// portrait mode
                    VStack(alignment: .center, spacing: 0) {
                        ContentGroupView(
                            heightLimit: min(
                                geo.size.width,
                                /// consume at most 60% of height (otherwise it crushes lower elements)
                                geo.size.height * 0.6
                            ),
                            widthLimit:geo.size.width
                        )
                    }
                }
            }
            .background(offBG())
            .onAppear {
                /// load data immediately
//                self.loadData()
            }
            /// fade out loading screen when data is finished being requested
//            ProgressIndicator()
//                .opacity(self.loaded ? 0.0 : 1.0)
//                .animation(.linear)
        }
        
    }
    
    func loadData() {
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
                    case let .success(report):
                        /// hand back the complete report
                        self.data.report = report
                        /// and remove the loading screen
                        self.loaded = true
                        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
