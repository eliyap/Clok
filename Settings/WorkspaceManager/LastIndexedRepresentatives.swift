//
//  LastIndexedRepresentatives.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 26/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

struct RepresentativeMarker: Codable {
    ///  a `TimeEntry` id
    var id: Int64 = .zero
    
    /// the date of the most recently indexed `TimeEntry`
    var lastIndexed = Date()
}

extension WorkspaceManager {
    // MARK:- Date that TimeEntry Representatives were Last Indexed
    private static let lastIndexedRepresentativesKey = "Clok.Representatives"
    
    static var lastIndexedRepresentatives: RepresentativeMarker {
        get {
            guard let decoded = suite?.object(forKey: Self.lastIndexedRepresentativesKey) as? Data else {
                return RepresentativeMarker()
            }
            do {
                return try JSONDecoder().decode(RepresentativeMarker.self, from: decoded)
            } catch {
                #if DEBUG
                assert(false, "Unable to decode RepresentativeMarker!")
                #endif
                return RepresentativeMarker()
            }
        }
        set {
            suite?.setValue(try! JSONEncoder().encode(newValue), forKey: Self.lastIndexedRepresentativesKey)
        }
    }
}
