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
            List {
            
            }
        default:
            EmptyView()
        }
    }
}
