//
//  UpdatedEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct UpdatedEntry: Decodable {
    let data: Details
    
    struct Details: Decodable {
        /// timestamp of successful update
        let at: Date
        
        /// note, name differs from `RawTimeEntry`
        let billable: Bool
        
        /// NOTE: if `description` == "", the field will be absent.
        let description: String?
        let start: Date
        let stop: Date
        let duration: Double
        let tags: [String]
        let id: Int64
        let pid: Int?
        let uid: Int; // user ID
        
        /// present in the blob, but unused by `Clok`
        //    duronly = 0;
        //    guid = <some long hex thing>;
        //    wid
    }
}


