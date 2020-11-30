//
//  Entry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 30/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

/// a data type with the general shape of a `TimeEntry`
protocol TimeEntryLike {
    var start: Date { get }
    var end: Date { get }
    var color: Color { get }
    /**
     Note: after numerous searches and some pain, I found
     https://stackoverflow.com/questions/55996678/associated-protocol-in-swift
     What I want is an `associatedprotocol`, which does not exist
     */
    //var project: ProjectType { get }
}
