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
    // detect the device size class
    // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
    @Environment(\.verticalSizeClass) var heightClass
    
    var body : some View {
        GeometryReader {geo in
            HStack {
                // landscape mode
                if geo.size.width > geo.size.height {
                    SpiralUI(self.report)
                    EntryList(report: self.report)
                } else {
                    // portrait mode
                    // switch to a VStack (HStack with only 1 element has no effect)
                    VStack(alignment: .center) {
                        SpiralUI(self.report)
//                        TimeEntryList()
                        EntryList(report: self.report)
                    }
                }
            } .onAppear { // load data immediately
                self.loadData()
            }

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
                    self.report = myReport
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
        ContentView(report: Report())
    }
}
