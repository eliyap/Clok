//
//  User.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct Workspace: Identifiable {
    var id: Int
}

struct User {
    var token: String
    var email: String
    var fullName: String
    var workspaces = [Workspace]()
    
    init?(_ json:Dictionary<String, AnyObject>) {
        print("received json")
        // unwrap optionals
        guard
            let data = json["data"] as? [String: AnyObject],
            let _token = data["api_token"] as? String,
            let _email = data["email"] as? String,
            let _name = data["fullname"] as? String,
            let _spaces = data["workspaces"] as? [[String: AnyObject]]
        else {
            return nil
        }
        
        token = _token
        email = _email
        fullName = _name
        
        _spaces.forEach {
            if let id = $0["id"] as? Int {
                workspaces.append(Workspace(id: id))
            }
        }
        print("created user")
        /// must have at least 1 workspace ID to function!
        guard workspaces.count > 0 else {
            return nil
        }
        print("found workspace")
    }
    
    init(token token_: String, email email_: String, name: String){
        token = token_
        email = email_
        fullName = name
        workspaces = []
    }
}
