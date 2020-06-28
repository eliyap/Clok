//
//  LoadData.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
extension ContentView {
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
