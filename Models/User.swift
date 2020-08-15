//
//  User.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

fileprivate struct RawUserData: Decodable {
    let data: RawUser
    struct RawUser: Decodable {
        var api_token: String
        var email: String
        var fullname: String
        var workspaces: [Workspace]
    }
}

struct User: Decodable {
    var token: String
    var email: String
    var fullName: String
    var workspaces: [Workspace]
    var chosen: Workspace
    
    init(from decoder: Decoder) throws {
        let rawUser = try RawUserData(from: decoder).data
        token = rawUser.api_token
        email = rawUser.email
        fullName = rawUser.fullname
        workspaces = rawUser.workspaces
        /// must have at least 1 workspace
        guard workspaces.count > 0 else { throw NetworkError.serialization }
        
        /// default to first workspace
        chosen = workspaces[0]
    }
    
//    init?(_ json: [String: AnyObject]) {
//        // unwrap optionals
//        guard
//            let data = json["data"] as? [String: AnyObject],
//            let _token = data["api_token"] as? String,
//            let _email = data["email"] as? String,
//            let _name = data["fullname"] as? String,
//            let _spaces = data["workspaces"] as? [[String: AnyObject]]
//        else {
//            return nil
//        }
//        
//        token = _token
//        email = _email
//        fullName = _name
//        
//        /// must have at least 1 workspace
//        guard _spaces.count > 0 else { return nil }
//        workspaces = [] // initialize before capture
//        chosen = .none
//        _spaces.forEach {
//            if let wid = $0["id"] as? Int, let name = $0["name"] as? String {
//                workspaces.append(Workspace(wid: wid, name: name))
//            }
//        }
//        chosen = workspaces[0]
//    }
    
    init?(
        token token_: String,
        email email_: String,
        name: String,
        spaces: [Workspace]?,
        chosen chosen_: Workspace
    ){
        token = token_
        email = email_
        fullName = name
        guard let spaces = spaces else { return nil }
        workspaces = spaces
        chosen = chosen_
    }
}
