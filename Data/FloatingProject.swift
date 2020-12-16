//
//  FloatingProject.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 13/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

final class FloatingProject: Project {
    init(
        id: Int,
        name: String,
        hex_color: String,
        context: NSManagedObjectContext
    ) {
        super.init(
            raw: RawProject(
                id: NSNotFound,
                is_private: false, /// irrelevant value
                wid: NSNotFound, /// irrelevant value
                hex_color: hex_color,
                name: name,
                billable: false, /// irrelevant value
                at: .distantPast /// irrelevant value
            ),
            context: context
        )
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
