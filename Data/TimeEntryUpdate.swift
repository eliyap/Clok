//
//  TimeEntryUpdate.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 19/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation

extension TimeEntry {
    func update(from model: EntryModel) -> Void {
        
        self.start = model.start
        self.end = model.end
        self.billable = model.billable
        self.name = model.entryDescription
        
        switch model.project {
        case .project(let project):
            self.project = project
        case .special(.NoProject):
            self.project = nil
        case .special(_):
            fatalError("Tried to store StaticProject!")
        case .lite(_):
            fatalError("Tried to store LiteProject!")
        }
    }
}
