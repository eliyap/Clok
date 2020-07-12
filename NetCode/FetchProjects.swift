//
//  FetchProjects.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

extension ContentView {
    func fetchProjects(
        token: String,
        wid: Int,
        in context: NSManagedObjectContext
    ) -> [Project]? {
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/workspaces.md#get-workspace-projects
        
        let result = getProjects(
            request:  formRequest(
                url: URL(string: "\(API_URL)/workspaces/\(wid)/projects?user_agent=\(user_agent)")!,
                auth: auth(token: token)
            ),
            context: context
        )
        var projects: [Project]? = nil
        DispatchQueue.main.async {
            switch result {
            case let .success(newProjects):
                print(newProjects.count)
                try! moc.save()
                projects?.forEach{print($0.wrappedName)}
            case .failure(.request):
                // temporary micro-copy
                print("We weren't able to fetch your data. Maybe the internet is down?")
            case let .failure(error):
                print(error)
            }
        }
        return projects
    }

    func getProjects(request: URLRequest, context: NSManagedObjectContext) -> Result<[Project], NetworkError> {
        var result: Result<[Project], NetworkError>!
        var projects = [Project]()
        
        // semaphore for API call
        let sem = DispatchSemaphore(value: 0)
        
        //define completionHandler
        let handler = {(data: Data?, resp: URLResponse?, error: Error?) -> Void in
            defer{ sem.signal() }
            
            guard error == nil else {
                result = .failure(.request(error: error! as NSError))
                return
            }
            guard
                let http_response = resp as? HTTPURLResponse,
                let data = data
            else {
                return
            }
            guard http_response.statusCode == 200 else {
                result = .failure(.statusCode(code: http_response.statusCode))
                return
            }
            do {
                let decoder = JSONDecoder(context: context)
                projects = try decoder.decode([Project].self, from: data)
            } catch {
                print(error)
                result = .failure(.serialization)
            }
        }
        
        URLSession.shared.dataTask(
            with: request,
            completionHandler: handler
        ).resume()
        
        /// wait here until call returns, or timeout if it took too long
        if sem.wait(timeout: .now() + 15) == .timedOut { return .failure(.timeout) }
        
        /// only return success if there is no failure
        switch result {
        case .failure(_):
            return result
        default:
            return .success(projects)
        }
    }
}

