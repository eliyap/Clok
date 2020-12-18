//
//  RunningEntry_NSSecureEncoding.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

//MARK:- NSSecureCoding Compliance
extension RunningEntry: NSSecureCoding {
    
    static var supportsSecureCoding = true
    
    /**
     NOTE: this init only finds `pid`, it does not use that to get the associated `project`
     This is so that we do not need to make `projectLike` `NSSecureCoding` compliant.
     Whatever decodes this will need to do its own work to find the `project`.
     */
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(pid, forKey: "pid")
        coder.encode(start, forKey: "start")
        coder.encode(entryDescription, forKey: "entryDescription")
        coder.encode(tags, forKey: "tags")
    }
    
    init?(coder: NSCoder) {
        id = Int64(coder.decodeInteger(forKey: "id"))
        pid = Int64(coder.decodeInteger(forKey: "pid"))
        
        /// note: we will assign project later, for now leave `unknown`
        project = ProjectPresets.shared.UnknownProject
        
        tags = coder.decodeObject(forKey: "tags") as? [String]
            ?? []
        billable = coder.decodeBool(forKey: "billable")
        
        guard
            let start = coder.decodeObject(forKey: "start") as? Date,
            let entryDescription = coder.decodeObject(forKey: "entryDescription") as? String
        else { return nil }
        self.start = start
        self.entryDescription = entryDescription
        
    }
}
