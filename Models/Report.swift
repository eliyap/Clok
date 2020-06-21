//
//  Report.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.03.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

final class Report : ObservableObject {
    // unpacked from Toggl JSON
    var total_grand:Int          // total seconds tracked
    var total_count:Int          // total number of time entries in the report
    var per_page:Int             // number of time entries provided per request
    var entries:[TimeEntry] = [] // list of TimeEntry's
    
    // my stuff, not from the Toggl API
    var minDate = Date() // used as zeroDate to cut off entries that are too early
    var maxDate = Date() // cuts off entries that are too late
    
    init(_ json:Dictionary<String, AnyObject>){
        // unwrap optionals
        guard
            let total_grand = json["total_grand"] as? Int,
            let total_count = json["total_count"] as? Int,
            let per_page = json["per_page"] as? Int
        else {
            // this should probably be an error
            // but I don't know how to do that yet
            
            print("One or more report parameters not initialized!")
            (self.total_grand, self.total_count, self.per_page) = (0,0,0)
            return
        }
        
        self.total_grand = total_grand
        self.total_count = total_count
        self.per_page = per_page
        
        if let data = json["data"] as? [Dictionary<String, AnyObject>] {
            data.forEach { i in
//              if init fails, do not append
                if let newEntry = TimeEntry(i) {
                    self.entries.append(newEntry)
                }
            }
        } else {
            print("could not coerce!")
        }
    }
    
    // initializes an empty Report for convenience
    init () {
        self.total_grand = -1
        self.total_count = -1
        self.per_page = -1
    }
}
