//
//  ProjectLite.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 18/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// Defines a lightweight structure useful for conveying some `Project` attributes without
/// spawning a full fledged `CoreData` object.
/// Distinct from `StaticProject` so as to avoid confusion.
struct ProjectLite: Codable {
    let color: Color
    let name: String
    let id: Int64
    
    init(
        color: Color,
        name: String,
        id: Int64
    ) {
        self.color = color
        self.name = name
        self.id = id
    }
    
    private enum Keys: String, CodingKey {
        case id = "id"
        case name = "name"
        case color = "color"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int64.self, forKey: .id)
        
        let colorData = try container.decode(Data.self, forKey: .color)
        let uiColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor
            ?? UIColor.clear /// use `clear` as it will make mistakes very obvious
        /// NOTE: use my own casting, because SwiftUI's is friggin broken
        color = uiColor.color
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }
}

/// convinient copies of some special values
extension ProjectLite {
    static let NoProjectLite = ProjectLite(
        color: StaticProject.NoProject.color,
        name: StaticProject.NoProject.name,
        id: StaticProject.NoProject.id
    )
    
    static let UnknownProjectLite = ProjectLite(
        color: StaticProject.UnknownProject.color,
        name: StaticProject.UnknownProject.name,
        id: StaticProject.UnknownProject.id
    )
    
    static let AnyProjectLite = ProjectLite(
        color: StaticProject.AnyProject.color,
        name: StaticProject.AnyProject.name,
        id: StaticProject.AnyProject.id
    )
}

extension ProjectLite: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(color)
    }
}
