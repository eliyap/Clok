//
//  Project+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import SwiftUI
import CoreData

/// simplify decoding
fileprivate struct RawProject: Decodable {
    var id: Int
    var is_private: Bool
    var wid: Int
    var hex_color: String
    var name: String
    var billable: Bool
    // one of these cases a coding failure, ignore for now
//        var actual_hours: Int
//        var color: Int // probably an enum for toggl's default color palette
}

@objc(Project)
public class Project: NSManagedObject, Decodable, ProjectLike {
    
    static let entityName = "Project" /// for making entity calls
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }

        super.init(entity: Project.entity(), insertInto: context)
        
        let rawProject = try RawProject(from: decoder)
        id = Int64(rawProject.id)
        color = rawProject.hex_color
        name = rawProject.name
    }
    
    
    
    static func == (lhs: Project, rhs: ProjectLike) -> Bool {
        lhs.name == rhs.name && lhs.wrappedID == rhs.wrappedID
    }
    
    func matches(_ other: ProjectLike) -> Bool {
        /// Any Project matches all other projects
        self == other || .any == other  || self == StaticProject.any
    }
    
    static func < (lhs: Project, rhs: ProjectLike) -> Bool {
        /// No Project should always be first
        if StaticProject.noProject == lhs  { return true }
        if StaticProject.noProject == rhs  { return false }
        return lhs.name < rhs.name
    }
    
    init(in context: NSManagedObjectContext?, name: String, colorHex: String, id: Int){
        super.init(entity: Project.entity(), insertInto: context)
        self.name = name
        self.id = Int64(id)
        self.color = colorHex
    }
    
    init(context: NSManagedObjectContext){
        super.init(entity: Project.entity(), insertInto: context)
    }
}
