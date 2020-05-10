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

// makes HTTP-requests and parses data from the Toggl API
// utilizing semaphore method from https://medium.com/@michaellong/swift-5-async-await-result-gcd-and-timeout-1f1652d7adcf
func toggl_request(
    detailsURL: URL,
    token: String
) -> Result<Report, NetworkError> {
    var page = 0
    var result: Result<Report, NetworkError>!
    var report: Report!
    // semaphore for API call
    let sem = DispatchSemaphore(value: 0)
    
    //define completionHandler
    let myHandler = {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        guard
            let http_response = resp as? HTTPURLResponse,
            let data = data
        else {
            result = .failure(.other)
            sem.signal()
            return
        }
        guard http_response.statusCode == 200 else {
            result = .failure(.statusCode)
            sem.signal()
            return
        }
        
        // all checks passed
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            switch page {
            case 0:
                // first call gets meta-data (number of Entry's to expect)
                report = Report(json as! Dictionary<String, AnyObject>)
            default:
                // subsequent calls simply append results to report
                report.entries += Report(json as! Dictionary<String, AnyObject>).entries
            }
            sem.signal()
        } catch {
            result = .failure(.other)
            sem.signal()
            return
        }
    }
    
    // send request
    repeat {
        
        // append page no. to URL
        let page_url = detailsURL.appendingPathComponent("&page=\(page)", isDirectory: false)
        var request = URLRequest(url: page_url)
        
        // set headers
        let auth = Data("\(token):api_token".utf8).base64EncodedString()
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request, completionHandler: myHandler).resume()
        
        // wait for call to complete
        if sem.wait(timeout: .now() + 15) == .timedOut {
            // abort if call takes too long
            return .failure(.timeout)
        }
        
        // request next page of data
        page += 1
    } while(report.entries.count < report.total_count)
    result = .success(report)
    
    // wait for request to complete
    return result
}
