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
    // the Project and Descriptions the user is filtering for
    @Published var terms = SearchTerm(
        project: StaticProject.any,
        description: "",
        byDescription: .any
    )
    
    // true when user is changing the search terms
    @Published var searching = false
    @Published var projects = [Project]()
}
