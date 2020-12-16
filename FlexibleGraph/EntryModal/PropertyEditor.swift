//
//  PropertyEditor.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 16/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct PropertyEditor: View {
    
    @ObservedObject var model: EntryModel
    
    /// since the `internalModel` does not receive updates to `Field`, pass this in explicitly
    let field: EntryModel.Field?
    
    let dismiss: () -> Void
    
    let boundingWidth: CGFloat
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
    ) var projects: FetchedResults<Project>
    
    var body: some View {
        switch field {
        case .start:
            DatePicker("Start Time", selection: $model.start, in: ...model.end)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
        case .end:
            DatePicker("End Time", selection: $model.end, in: model.start...)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
        case .project:
//            List {
//                Text("Projects")
//                ForEach(projects, id: \.id) { project in
//                    Text(project.name)
//                }
//            }
            ProjectPicker(
                projects: projects,
                selected: $model.project,
                dismiss: dismiss,
                boundingWidth: boundingWidth
            )
                
        default:
            EmptyView()
        }
    }
}
