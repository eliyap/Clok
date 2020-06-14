//
//  ContentView.swift
//  Landwarks
//
//  Created by Secret Asian Man 3 on 20.04.16.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State var report = Report()
    
    /// indicates whether we are finished loading data
    @State var loaded = false
    
    @EnvironmentObject var zero:ZeroDate
    
    var body : some View {
        ZStack {
            GeometryReader {geo in
                if geo.size.width > geo.size.height {
                    /// landscape mode
                    HStack(spacing: 0) {
                        ZStack{
                            SpiralUI(self.report)
                            SpiralControls()
                        }
                            .frame(width: geo.size.width * 0.60)
                        CustomTableView(self.zero.frame.within(self.report.entries))
                    }
                } else {
                    /// portrait mode
                    VStack(alignment: .center, spacing: 0) {
                        ZStack{
                            SpiralUI(self.report)
                            SpiralControls()
                        }
                            .frame(height: geo.size.height * 0.60)
                        CustomTableView(self.zero.frame.within(self.report.entries))
                    }
                }
            }.onAppear {
                /// load data immediately
                self.loadData()
            }
            /// fade out loading screen when data is finished being requested
            ProgressIndicator()
                .opacity(self.loaded ? 0.0 : 1.0)
                .animation(.linear)
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
                    case let .success(myReport):
                        /// hand back the complete report
                        self.report = myReport
                        /// and remove the loading screen
                        self.loaded = true
                        
                        #if DEBUG
                        print("Fetched \(self.report.entries.count) entries in total")
    //                    print(report.entries.max(){$0.start > $1.start}?.start)
    //                    print(report.entries.min(){$0.start > $1.start}?.start)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
