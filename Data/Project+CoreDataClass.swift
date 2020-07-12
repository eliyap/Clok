//
//  CDProject+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import SwiftUI
import CoreData

@objc(Project)
public class Project: NSManagedObject {
    
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
}
