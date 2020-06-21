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
    @Published var report = Report()
    
    func projects() -> Set<Project> {
        Set(self.report.entries.map{$0.project})
    }
}

