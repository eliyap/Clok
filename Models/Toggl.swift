//
//  Toggl.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.03.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case url
    case request
    case server
    case timeout
    case statusCode
    case other // bad practice, in future try to figure out how I can have some
    // generic error for handling non-network errors
}

// makes HTTP-requests and parses data from the Toggl API
// utilizing semaphore method from https://medium.com/@michaellong/swift-5-async-await-result-gcd-and-timeout-1f1652d7adcf
func toggl_request(
    api_string: String,
    token: String
) -> Result<Report, NetworkError> {
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
            #if DEBUG
            // could put more detailed error handling here, nut unsure how to do so
            // use NSError.code to to get reason for failure? e.g. I think -1009 is "no internet"
            print(error! as NSError)
            #endif
            result = .failure(.request)
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
            result = .failure(.statusCode)
            return
        }
        
        // all checks passed
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            switch page {
            case 1:
                // first call gets meta-data (number of Entry's to expect)
                report = Report(json as! Dictionary<String, AnyObject>)
            default:
                // subsequent calls simply append results to report
                let new_entries = Report(json as! Dictionary<String, AnyObject>).entries
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
        
        // append page no. to URL
        let page_url = URL(string: api_string + "&page=\(page)")!
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
        if emptyReq {
            // if nothing was found, stop requesting!
            break page_loop
        }
        // request next page of data
        page += 1
    } while(report.entries.count < report.total_count)
    
    // only return success if there is no failure
    switch result {
    case .failure(_):
        return result
    default:
        return .success(report)
    }
    
}
