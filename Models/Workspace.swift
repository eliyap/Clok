//
//  Workspace.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 15/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

class Workspace: NSObject, NSSecureCoding, Decodable {
    static var supportsSecureCoding: Bool = true
    
    var wid: Int
    var name: String
    
    static let none = Workspace(wid: NSNotFound, name: "None")
    
    init(wid: Int, name: String) {
        self.wid = wid
        self.name = name
    }

    // MARK: - NSCoding
    required init(coder: NSCoder) {
        wid = coder.decodeObject(forKey: "wid") as? Int ?? coder.decodeInteger(forKey: "wid")
        name = coder.decodeObject(forKey: "name") as! String
    }

    func encode(with coder: NSCoder) {
        coder.encode(wid, forKey: "wid")
        coder.encode(name, forKey: "name")
    }
}
