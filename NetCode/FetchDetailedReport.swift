//
//  Toggl.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.03.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

// makes HTTP-requests and parses data from the Toggl API
// utilizing semaphore method from https://medium.com/@michaellong/swift-5-async-await-result-gcd-and-timeout-1f1652d7adcf
func fetchDetailedReport(
    api_string: String,
    token: String,
    context: NSManagedObjectContext
) -> Result<[TimeEntry], NetworkError> {
    var page = 1 // pages are indexed from 1
    var result: Result<[TimeEntry], NetworkError>!
    var emptyReq = false // flag for when a request returns no entries
    
    // initialize as empty to prevent crashes when offline
    var report = Report.empty
    
    // semaphore for API call
    let sem = DispatchSemaphore(value: 0)
    
    /// Request completionHandler
    let myHandler = {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        /// release semaphore regardless of success
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
            print(http_response)
            return
        }
        
        do {
            let decoder = JSONDecoder(context: context)
            decoder.dateDecodingStrategy = .iso8601
            switch page {
            case 1:
                report = try decoder.decode(Report.self, from: data)
                break
            default:
                let new_entries = try decoder.decode(Report.self, from: data).entries
                guard new_entries.count > 0 else {
                    // return expression had nothing!
                    // cease requests, preventing infinite polling of the API
                    emptyReq = true
                    return
                }
                report.entries += new_entries
                break
            }
        } catch {
            print(error)
            result = .failure(.serialization)
            return
        }
    }
    
    // keep requesting until we have all data
    page_loop: repeat {
        URLSession.shared.dataTask(
            with: formRequest(
                url: URL(string: api_string + "&page=\(page)")!,
                auth: auth(token: token)
            ),
            completionHandler: myHandler
        ).resume()
        
        /// wait 15s for call to complete
        if sem.wait(timeout: .now() + 15) == .timedOut { return .failure(.timeout) }
        
        /// if nothing was found, cease requests
        if emptyReq { break page_loop }
        
        /// if error was encountered, stop immediately
        if case .failure(_) = result { return result }
        
        /// request next page
        page += 1
    } while(report.entries.count < report.totalCount)
    
    // only return success containing report if nothing failed
    switch result {
    case .failure(_):
        return result
    default:
        return .success(report.entries)
    }
}
