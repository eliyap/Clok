//
//  DetailedEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 28/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

// MARK:- Detailed Report Entry
extension Detailed {
    struct Entry: Hashable {
        let description: String
        
        let start: Date
        let end: Date
        let dur: Double
        
        let id: Int
        let billable: Bool
                
        let tags: [String]

        /// ignore these attributes
        // let updated: Date
        // let uid: Int; // user ID
        // let use_stop: Bool
        // let user: String
        
        init(raw: RawTimeEntry){
            self.description = raw.description
            self.start = raw.start
            self.end = raw.end
            self.dur = raw.dur / 1000 /// convert from ms to s
            self.id = raw.id
            self.billable = raw.is_billable
            self.tags = raw.tags
        }
    }
}
