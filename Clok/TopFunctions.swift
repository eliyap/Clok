//
//  TopFunctions.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

extension ContentView {
    func tryLoadUserFromDisk() {
        /// try to find user credentials
        if let user = getCredentials() {
            settings.user = user
        } else {
            print("could not retrieve user from disk")
        }
    }
    
    func fetchData(user: User?) {
        // do nothing if token is nil (user is not logged in)
        guard let user = user else { return }
        
        // request user data
        fetchEntries(
            token: user.token,
            wid: user.chosen.wid,
            from: Date() - weekLength,
            to: Date(),
            in: moc
        )
    }
    
    
//    TOP LEVEL SANDBOX
    func testRunning() -> Void {
        
        var project = OldProject.noProject
        let sem = DispatchSemaphore(value: 0)
        let token = "cfae5db4249b8509ca7671259598c2fb"
        let pid = 158395089

        URLSession.shared.dataTask(with: formRequest(
            url: URL(string: "\(API_URL)/projects/\(pid)\(agentSuffix)")!,
            auth: auth(token: token)
        )) {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
            // release process when complete
            defer{ sem.signal() }

            guard let data = data else {
//                completion(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder(context: moc)
//                Project(context: moc)
                let newProj = try decoder.decode(Project.self, from: data)
                print(newProj.name)
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
//                guard
//                    json["data"] != nil,
//                    let data = json["data"] as? [String: AnyObject],
//                    let proj = OldProject(from: data)
//                else {
////                    completion (nil, NetworkError.serialization)
//                    return
//                }
//                print(data)
//                project = proj
            } catch {
                print("project initialization failed!")
//                completion(nil, NetworkError.serialization)
                return
            }
        }.resume()

        // wait for 2nd request to complete
        if sem.wait(timeout: .now() + 15) == .timedOut {
//            completion(nil, NetworkError.timeout)
            return
        }
    }
    
}
