//  BackgrounRequest.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation
import CoreData

func fetchRunningEntry(context: NSManagedObjectContext, completion:@escaping (RunningEntry?, Error?) -> Void) {
    var data: [String: AnyObject]!
    
    guard let token = try? getKey().2 else {
        completion(nil, KeychainError.noData)
        return
    }
    
    URLSession.shared.dataTask(with: formRequest(
        url: runningURL,
        auth: auth(token: token)
    )) {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
        
        /// check the status code
        let code = (resp as? HTTPURLResponse)?.statusCode
            ?? -1
        if !(200...299).contains(code) {
            print(resp.debugDescription)
            completion(nil, NetworkError.statusCode(code: code))
            return
        }

        guard let data = data else {
            completion(nil, error)
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
            
            /// timer might not be running, in which case `null` is returned
            guard let
                data = json["data"] as? [String : AnyObject]
            else {
                completion (.noEntry, nil)
                return
            }
            
            /// project is `unknown` by default
            var project: ProjectLike = StaticProject.unknown
            
            /// check Project ID against Core Data list
            if let pid = data["pid"] as? Int {
                project = loadProjects(context: context)?
                    .first(where: {$0.wrappedID == pid})
                    ?? StaticProject.unknown
            } else {
                /// if no PID, means no project
                project = StaticProject.noProject
            }
            
            /// initialize object with known project
            guard let running = RunningEntry(from: data, project: project) else {
                completion(nil, NetworkError.serialization)
                return
            }
            
            /// success!
            completion(running, nil)
            return
        } catch {
            completion(nil, NetworkError.serialization)
            return
        }
    }.resume()
}

