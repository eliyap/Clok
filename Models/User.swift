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
        var beginning_of_week: Int
    }
}

struct User: Decodable {
    var token: String
    var email: String
    var fullName: String
    var workspaces: [Workspace]
    var chosen: Workspace
    var firstDayOfWeek: Int
    
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
        
        /** https://github.com/toggl/toggl_api_docs/blob/master/chapters/users.md
         Refer to documentation, Toggl runs 0-6 (Sunday = 0),
         whereas Apple runs 1-7 (Sunday = 1).
         Hence we adjust by 1 when converting
         */
        firstDayOfWeek = rawUser.beginning_of_week + 1
        WidgetManager.firstDayOfWeek = firstDayOfWeek
    }
    
    init?(
        token: String,
        email: String,
        name: String,
        spaces: [Workspace]?,
        chosen: Workspace,
        firstDayOfWeek: Int
    ){
        self.token = token
        self.email = email
        self.fullName = name
        guard let spaces = spaces else { return nil }
        self.workspaces = spaces
        self.chosen = chosen
        self.firstDayOfWeek = firstDayOfWeek
    }
}
