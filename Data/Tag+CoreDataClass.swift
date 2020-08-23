//
//  Tag+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 23/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import CoreData

fileprivate struct RawTag: Decodable {
    /// name, guaranteed unique among within the workspace,
    /// https://github.com/toggl/toggl_api_docs/blob/b19c3b61f2b1be2eeccc28ea4e6acee38cfc72a1/chapters/tags.md#tags
    let name: String
    
    /// `Workspace` ID that this tag belongs to
    let wid: Int
    
    /// tag ID
    let id: Int
    
    /// update / creation (?) date
    let at: Date
}

@objc(Tag)
public class Tag: NSManagedObject {
    static let entityName = "Tag"
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }

        super.init(entity: Tag.entity(), insertInto: context)
        
        let rawTag = try RawTag(from: decoder)
        id = Int64(rawTag.id)
        wid = Int64(rawTag.wid)
        name = rawTag.name
    }
}
