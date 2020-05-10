//
//  Toggl.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.03.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
let entry = [TimeEntry( // placeholder var until things are hooked up properly
    [:] // Feb 2, 1997, 10:26 AM
    //    end: Date(timeIntervalSinceReferenceDate: -123355789.0) // Feb 2, 1997, 10:26 AM
    )]

enum NetworkError: Error {
    case url
    case server
    case timeout
    case statusCode
    case other // bad practice, in future try to figure out how I can have some
    // generic error for handling non-network errors
}

// makes API calls until all pages are fetched
func toggl_request(token: String) -> Report{
    
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
    
    
    
    
    var report = Report([:])
    DispatchQueue.global(qos: .utility).async {
        var bigSem = DispatchSemaphore(value: 0)
        let result = toggl_helper(
            old: Result<Report, NetworkError>.success(report),
            detailsURL: detailsURL,
            page: 0,
            token: token,
            sem: bigSem
        )
        bigSem.wait()
//            .flatMap{toggl_helper(old: Result<Report, NetworkError>.success($0), detailsURL: detailsURL, page: 1, token: token)}
        DispatchQueue.main.async {
            switch result {
            case let .success(myReport):
                report = myReport
            case let .failure(error):
            //    print(error)
            }
        }
    }
    
    
    
    
    
    
    

    print("\(report.total_count) entries found. Now fetching...")
    return report
}

// HTTP-requests and parses data from the Toggl API
// utilizing semaphore method from https://medium.com/@michaellong/swift-5-async-await-result-gcd-and-timeout-1f1652d7adcf
func toggl_helper(
    old: Result<Report, NetworkError>,
    detailsURL: URL,
    page: Int,
    token: String,
    sem: DispatchSemaphore
) -> Result<Report, NetworkError> {
    var result: Result<Report, NetworkError>!
    // semaphore for API call
    var callSem = DispatchSemaphore(value: 0)
    print("Page \(page)") // DEBUG
    
    //define completionHandler
    let myHandler = {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        guard
            let http_response = resp as? HTTPURLResponse,
            let data = data
        else {
            result = .failure(.other)
            callSem.signal()
            return
        }
        guard http_response.statusCode == 200 else {
            result = .failure(.statusCode)
            callSem.signal()
            return
        }
        
        // all checks passed
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            result = .success(Report(json as! Dictionary<String, AnyObject>))
            
            try print("\(result.get().per_page) entries fetched")
            if (page < 3){
//                result = result.flatMap{toggl_helper(old: $0, detailsURL: detailsURL, page: page + 1, token: token)}
            }
            callSem.signal()
        } catch {
            print(error)
        }
    }
    
    // append page no.
    let page_url = detailsURL.appendingPathComponent("&page=\(page)", isDirectory: false)
    var request = URLRequest(url: page_url)
    
    // set headers
    let auth = Data("\(token):api_token".utf8).base64EncodedString()
    request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // send request
    URLSession.shared.dataTask(with: request, completionHandler: myHandler).resume()
    
    // wait for request to complete
    _ = callSem.wait(wallTimeout: .distantFuture)
    sem.signal()
    return result
}
