//
//  TimeEntry+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import Foundation
import SwiftUI
import CoreData

fileprivate struct RawTimeEntry: Decodable {
    var description: String
    
    var start: Date
    var end: Date
    var dur: Double
    var updated: Date
    
    var id: Int
    var is_billable: Bool
    
    var pid: Int?
    var project: String?
    var project_hex_color: String?
    
    var uid: Int; // user ID
    var use_stop: Bool
    var user: String
    //    tags =     ();
    //    task = "<null>";
    //    tid = "<null>";
}

@objc(TimeEntry)
public class TimeEntry: NSManagedObject, Decodable {
    static let entityName = "TimeEntry"
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
        super.init(entity: TimeEntry.entity(), insertInto: context)
//        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        
        let rawTimeEntry = try RawTimeEntry(from: decoder)
        name = rawTimeEntry.description
        start = rawTimeEntry.start
        end = rawTimeEntry.end
        dur = rawTimeEntry.dur
        lastUpdated = rawTimeEntry.updated
        id = Int64(rawTimeEntry.id)
        // fetch project based on PID?
    }
    
    typealias Dimensions = (start: CGFloat, end: CGFloat)
    
    func getDimensions(zero date: Date) -> Dimensions {
        var dims = Dimensions(start: .zero, end: .zero)
        let startInt = (wrappedStart > date) ? (wrappedStart - date) : TimeInterval.zero
        let endInt = (wrappedEnd > date) ? (wrappedEnd - date) : TimeInterval.zero
        withAnimation(.spring()) {
            dims.start = archimedianSpiralLength(startInt * radPerSec) / weekSpiralLength
            dims.end = archimedianSpiralLength(endInt * radPerSec) / weekSpiralLength
        }
        return dims
    }
    
    /// Headlining description,
    /// or project if there's no description,
    /// or placeholder if no info whatsoever
    func descriptionString() -> String {
        if wrappedDescription == "" && wrappedProject == StaticProject.noProject {
            return "No Description"
        } else if wrappedDescription == "" {
            return wrappedProject.wrappedName
        } else {
            return wrappedDescription
        }
    }
}
