//
//  IntentHandler.swift
//  ProjectIntent
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import Intents

class IntentHandler: INExtension, ClokConfigurationIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func provideProject1OptionsCollection(for intent: ClokConfigurationIntent, with completion: @escaping (INObjectCollection<IntentProject>?, Error?) -> Void) {
        provideProjectOptionsCollection(for: intent, with: completion)
    }
    
    func provideProject2OptionsCollection(for intent: ClokConfigurationIntent, with completion: @escaping (INObjectCollection<IntentProject>?, Error?) -> Void) {
        provideProjectOptionsCollection(for: intent, with: completion)
    }
    
    func provideProject3OptionsCollection(for intent: ClokConfigurationIntent, with completion: @escaping (INObjectCollection<IntentProject>?, Error?) -> Void) {
        provideProjectOptionsCollection(for: intent, with: completion)
    }
    
    func provideProjectOptionsCollection(for intent: ClokConfigurationIntent, with completion: @escaping (INObjectCollection<IntentProject>?, Error?) -> Void) {
        // fetch credentials from Keychain
        guard let (_, _, token, chosenWID) = try? getKey() else {
            completion(INObjectCollection(items: []), nil)
            return
        }
        
        /// API URL documentation:
        /// https://github.com/toggl/toggl_api_docs/blob/master/chapters/workspaces.md#get-workspace-projects
        let request = formRequest(
            url: URL(string: "\(API_URL)/workspaces/\(chosenWID)/projects?user_agent=\(user_agent)")!,
            auth: auth(token: token)
        )
        
        /// fetch and decode RawProjects
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            guard error == nil else {
                completion(INObjectCollection(items: []), nil)
                return
            }
            guard let data = data else {
                completion(INObjectCollection(items: []), nil)
                return
            }
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard 200...299 ~= code else {
                completion(INObjectCollection(items: []), nil)
                return
            }
            do {
                let raws = try JSONDecoder(dateStrategy: .iso8601).decode([RawProject].self, from: data)
                completion(INObjectCollection(items:raws.map{
                    let proj = IntentProject(
                        identifier: "\($0.id)",
                        display: $0.name
                    )
                    proj.pid = NSNumber(value: $0.id)
                    return proj
                }), nil)
            } catch {
                completion(INObjectCollection(items: []), nil)
            }
        }.resume()
    }
}
