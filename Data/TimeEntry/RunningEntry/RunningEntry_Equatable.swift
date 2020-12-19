//
//  RunningEntry_Equatable.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension RunningEntry {
    /// define equality to allow comparison
    static func == (lhs: RunningEntry, rhs: RunningEntry) -> Bool {
        /// we could check everything, but unless the data is corrupted we really only need to check task ID
        /// NOTE: if in future we support editing of time entries, this check will need to be more rigorous
        return
            lhs.id == rhs.id &&
            lhs.start == rhs.start &&
            lhs.entryDescription == rhs.entryDescription &&
            /// perform a shallow Project ID check
            lhs.pid == rhs.pid
       }
}
