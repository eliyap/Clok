//
//  IntentHandler.swift
//  ProjectIntent
//
//  Created by Secret Asian Man Dev on 25/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Intents

class IntentHandler: INExtension, ClokConfigurationIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func provideProjectOptionsCollection(for intent: ClokConfigurationIntent, with completion: @escaping (INObjectCollection<IntentProject>?, Error?) -> Void) {
        let item = IntentProject(identifier: "a thing", display: "a thong")
        
        
        
        let collection = INObjectCollection(items: [item])
        completion(collection, nil)
    }
    
}
