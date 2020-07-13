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
    @Published var report = Report.empty
    
    // the Project and Descriptions the user is filtering for
    @Published var terms = SearchTerm(
        project: StaticProject.any,
        description: "",
        byDescription: .any
    )
    
    // true when user is changing the search terms
    @Published var searching = false
    
    func projects() -> [Project] {
        #warning("Re implement with Core Data")
        return []
        /// use set to make unique
//        Set(self.report.entries.map{$0.project})
//            .sorted()
    }
}

struct WithID<T>: Identifiable {
    var id = UUID()
    var val: T
}
