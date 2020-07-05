//
//  User.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

class Workspace: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var wid: Int
    var name: String
    
    init(wid: Int, name: String) {
        self.wid = wid
        self.name = name
    }

    // MARK: - NSCoding
    required init(coder: NSCoder) {
        wid = coder.decodeObject(forKey: "wid") as? Int ?? coder.decodeInteger(forKey: "wid")
        name = coder.decodeObject(forKey: "name") as! String
    }

    func encode(with coder: NSCoder) {
        coder.encode(wid, forKey: "wid")
        coder.encode(name, forKey: "name")
    }
}

struct User {
    var token: String
    var email: String
    var fullName: String
    var workspaces = [Workspace]()
    
    init?(_ json: [String: AnyObject]) {
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
            if let wid = $0["id"] as? Int, let name = $0["name"] as? String {
                workspaces.append(Workspace(wid: wid, name: name))
            }
        }
        
        /// must have at least 1 workspace ID to function!
        guard workspaces.count > 0 else { return nil }
    }
    
    init?(token token_: String, email email_: String, name: String, spaces: [Workspace]?){
        token = token_
        email = email_
        fullName = name
        guard let spaces = spaces else { return nil }
        workspaces = spaces
    }
}
