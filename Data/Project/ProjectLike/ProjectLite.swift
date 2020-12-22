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
final class ProjectLite: NSObject, NSCoding {
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
    
    // MARK: - NSCoding
    required init(coder: NSCoder) {
        id = coder.decodeInt64(forKey: Keys.id.rawValue)
        name = coder.decodeObject(forKey: Keys.name.rawValue) as! String
        color = Color(hex: coder.decodeObject(forKey: Keys.color.rawValue) as! String)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: Keys.name.rawValue)
        coder.encode(id, forKey: Keys.id.rawValue)
        coder.encode(color.toHex, forKey: Keys.color.rawValue)
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

extension ProjectLite: NSSecureCoding {
    static var supportsSecureCoding: Bool = true
}
