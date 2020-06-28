//
//  User.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct User {
    var token: String
    var workspaces: [String]
    
    init(_ json:Dictionary<String, AnyObject>){
        token = ""
        workspaces = []
        
        // unwrap optionals
        guard
            let data = json["data"] as? [String: AnyObject]
        else {
            // this should probably be an error
            // but I don't know how to do that yet
            token = ""
            workspaces = []
            return
        }
        print(data)
        
    }
}
