//
//  RequestConstants.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

/// lets Toggle know who I am
let user_agent = "emlyap99@gmail.com"
let agentSuffix = "?user_agent=\(user_agent)"

// MARK:- Request URLs
/// Base URLs
let API_URL = "https://www.toggl.com/api/v8"
let REPORT_URL = "https://toggl.com/reports/api/v2/"

/// https://github.com/toggl/toggl_api_docs/blob/master/chapters/users.md#get-current-user-data
let userDataURL = URL(string:"\(API_URL)/me\(agentSuffix)")!

/// https://github.com/toggl/toggl_api_docs/blob/master/chapters/time_entries.md#get-running-time-entry
let runningURL = URL(string: "\(API_URL)/time_entries/current\(agentSuffix)")!

// MARK:- Misc
/// for detailed reports, toggl dispenses at most 50 entries per request
/// https://github.com/toggl/toggl_api_docs/blob/master/reports/detailed.md#response
let togglPageSize = 50