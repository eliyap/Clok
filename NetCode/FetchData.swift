//
//  FetchData.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

func fetchData(
    token: String,
    wid: Int,
    from start: Date,
    to end: Date,
    in context: NSManagedObjectContext
) -> Void {
    // assemble request URL (page is added later)
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd" // ISO 8601 format, day precision
    
    // documented at https://github.com/toggl/toggl_api_docs/blob/master/reports.md
    let base_url = "https://toggl.com/reports/api/v2/"
    let api_string = "\(base_url)details?" + [
        "user_agent=\(user_agent)",    // identifies my app
        "workspace_id=\(wid)", // provided by the User
        "since=\(df.string(from: start))",
        "until=\(df.string(from: end))"
    ].joined(separator: "&")
    
//    let result = toggl_request(api_string: api_string, token: token)
//
//    DispatchQueue.main.async {
//        switch result {
//        case let .success(report):
//            break
//            /// hand back the complete report
////            data.report = report
//            /// and remove the loading screen
////            loaded = true
//
//        case .failure(.request):
//            // temporary micro-copy
//            print("We weren't able to fetch your data. Maybe the internet is down?")
//        case let .failure(error):
//            print(error)
//        }
//    }
}
