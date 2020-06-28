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
    
    func getWorkspaceIDs() -> Void {
        
        //define completionHandler
        let myHandler = {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
            
            guard error == nil else {
                #if DEBUG
                // could put more detailed error handling here, nut unsure how to do so
                // use NSError.code to to get reason for failure? e.g. I think -1009 is "no internet"
                print(error! as NSError)
                #endif
                return
            }
            guard
                let http_response = resp as? HTTPURLResponse,
                let data = data
            else {
                return
            }
            guard http_response.statusCode == 200 else {
                #if DEBUG
                print("Status Code \(http_response.statusCode)")
                print("\(http_response.allHeaderFields)")
                #endif
                return
            }
            
            // all checks passed
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                return
            }
        }
        
        
        
        // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
        let base_url = "https://www.toggl.com/api/v8/workspaces"
        let api_string = "\(base_url)?user_agent=\(user_agent)"
        
        // append page no. to URL
        let page_url = URL(string: api_string)!
        var request = URLRequest(url: page_url)
        
        // set headers
        let auth = Data("\(myToken):api_token".utf8).base64EncodedString()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request, completionHandler: myHandler).resume()
    }
}
