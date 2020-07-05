//  BackgrounRequest.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation

func getRunningEntry(completion:@escaping (RunningEntry?, Error?) -> Void) {
    let sem = DispatchSemaphore(value: 0)
    var project = Project.noProject
    var runningData: [String: AnyObject]!
    
    guard let token = getToken() else {
        completion(nil, KeychainError.noData)
        return
    }
    URLSession.shared.dataTask(with: formRequest(
        url: runningURL,
        auth: auth(token: token)
    )) {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        // release semaphore on exit
        defer{ sem.signal() }
        
        guard let data = data else {
            completion(nil, error)
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
            guard
                json["data"] != nil,
                let data = json["data"] as? [String : AnyObject]
            else {
                completion (nil, NetworkError.serialization)
                return
            }
            runningData = data
        } catch {
            completion(nil, NetworkError.serialization)
            return
        }
    }.resume()
    
    // wait for prior request to complete
    if sem.wait(timeout: .now() + 15) == .timedOut {
        completion(nil, NetworkError.timeout)
        return
    }
    
    /// timer might not be running
    guard
        runningData != nil,
        runningData["pid"] != nil,
        let pid = runningData["pid"] as? Int
    else {
        /// signal that no entry is currently running
        completion(RunningEntry.noEntry, nil)
        return
    }
    
    URLSession.shared.dataTask(with: formRequest(
        url: URL(string: "\(API_URL)/projects/\(pid)\(agentSuffix)")!,
        auth: auth(token: token)
    )) {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        // release process when complete
        defer{ sem.signal() }
        
        guard let data = data else {
            completion(nil, error)
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            guard
                json["data"] != nil,
                let data = json["data"] as? [String: AnyObject],
                let proj = Project(from: data)
            else {
                completion (nil, NetworkError.serialization)
                return
            }
            project = proj
        } catch {
            completion(nil, NetworkError.serialization)
            return
        }
    }.resume()
    
    // wait for 2nd request to complete
    if sem.wait(timeout: .now() + 15) == .timedOut {
        completion(nil, NetworkError.timeout)
        return
    }
    
    // sanity check, the project we requested was the one we received
    guard project.id == pid else { fatalError("\(project.id) and \(pid) do not match!") }
    guard let running = RunningEntry(from: runningData, project: project) else {
        completion(nil, NetworkError.serialization)
        return
    }
    /// success!
    completion(running, nil)
}
