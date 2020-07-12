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

fileprivate struct RawProject: Decodable {
    struct data: Decodable {
        var id: Int
        var is_private: Bool
        var wid: Int
        var hex_color: String
        var name: String
        var billable: Bool
        // one of these cases a coding failure, ignore for now
//        var actual_hours: Int
//        var color: Int
    }
    
    var data: data
}


@objc(Project)
public class Project: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
//        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        super.init(entity: Project.entity(), insertInto: context)
        print("made it this far")
        let rawProject = try RawProject(from: decoder)
        id = Int64(rawProject.data.id)
        color = rawProject.data.hex_color
        name = rawProject.data.name
    }
    
    static let noProject = Project(
        in: nil,
        name: "No Project",
        colorHex: Color.noProject.toHex,
        id: NSNotFound
    )
    
    static let any = Project(
        in: nil,
        name: "Any Project",
        colorHex: Color.secondary.toHex,
        id: Int.zero
    )
    
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
