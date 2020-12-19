//
//  RawTimeEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct RawTimeEntry: Decodable {
    let description: String
    
    let start: Date
    let end: Date
    let dur: Double
    let updated: Date
    
    let id: Int64
    let is_billable: Bool
    
    let pid: Int?
    let project: String?
    let project_hex_color: String?
    
    let uid: Int; // user ID
    let use_stop: Bool
    let user: String
    let tags: [String]
    //    task = "<null>";
    //    tid = "<null>";
}
