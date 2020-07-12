//
//  Toggl.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.03.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

// makes HTTP-requests and parses data from the Toggl API
// utilizing semaphore method from https://medium.com/@michaellong/swift-5-async-await-result-gcd-and-timeout-1f1652d7adcf
func toggl_request(api_string: String, token: String) -> Result<Report, NetworkError> {
    
    var page = 1 // pages are indexed from 1
    var result: Result<Report, NetworkError>!
    var emptyReq = false // flag for when a request returns no entries
    
    // initialize as empty to prevent crashes when offline
    var report: Report = Report([:])
    
    // semaphore for API call
    let sem = DispatchSemaphore(value: 0)
    
    //define completionHandler
    let myHandler = {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        // release semaphore whether or not code fails
        defer{ sem.signal() }
        guard error == nil else {
            result = .failure(.request(error: error! as NSError))
            return
        }
        guard
            let http_response = resp as? HTTPURLResponse,
            let data = data
        else {
            result = .failure(.other)
            return
        }
        guard http_response.statusCode == 200 else {
            result = .failure(.statusCode(code: http_response.statusCode))
            return
        }
        
        // all checks passed
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            switch page {
            case 1:
                // first call gets meta-data (number of Entry's to expect)
                report = Report(json as! [String: AnyObject])
            default:
                // subsequent calls simply append results to report
                let new_entries = Report(json as! [String: AnyObject]).entries
                guard new_entries.count > 0 else {
                    // return expression had nothing!
                    // causes requests to stop, this prevents infinite polling of the API
                    emptyReq = true
                    return
                }
                report.entries += new_entries
            }
        } catch {
            result = .failure(.other)
            return
        }
    }
    
    // send request
    page_loop: repeat {
        
        URLSession.shared.dataTask(
            with: formRequest(
                url: URL(string: api_string + "&page=\(page)")!,
                auth: auth(token: token)
            ),
            completionHandler: myHandler
        ).resume()
        
        // wait for call to complete, abort if it takes too long
        if sem.wait(timeout: .now() + 15) == .timedOut { return .failure(.timeout) }
        
        // if nothing was found, stop requesting!
        if emptyReq { break page_loop }
        
        // request next page of data
        page += 1
    } while(report.entries.count < report.total_count)
    
    // only return success containing report if nothing failed
    switch result {
    case .failure(_):
        return result
    default:
        return .success(report)
    }
}
