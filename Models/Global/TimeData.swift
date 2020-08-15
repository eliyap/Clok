//
//  Data.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

final class TimeData: ObservableObject {
    /// A delegate between SwiftUI and CoreData, storing all of the user's `TimeEntry`s
    /// `EnvironmentObject` was chosen to prevent the UI hitting CoreData on every refresh
    @Published var entries = [TimeEntry]()
    
    /// the `Project`s the user is filtering for
    @Published var terms = SearchTerms()
    
    /// a list of the user's `Project`s
    @Published var projects = [Project]()
}
